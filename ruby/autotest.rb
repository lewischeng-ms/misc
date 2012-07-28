#!/usr/bin/env ruby

$DEBUG = false

class Log
  @@stdout_mutex = Mutex.new
  @@stderr_mutex = Mutex.new

  def self.fatal(*args)
    @@stderr_mutex.synchronize do
      $stderr.puts args, "autotest exiting...."
    end
    exit(1)
  end
  
  def self.info(*args)
    @@stdout_mutex.synchronize do
      puts args
    end
  end
end

class DomainCommand
  def execute(cmd)
    Log.fatal "execute not implemented"
  end
  
  def super_execute(cmd)
    Log.fatal "super_execute not implemented"
  end
end

class Domain0Command < DomainCommand
  # consts
  DOMAIN0_USERNAME = 'snowwolf'
  DOMAIN0_PASSWORD = '123456'
  DOMAIN0_HOST = '192.168.1.169'
  DOMAIN0_PORT = 169
  
  attr_reader :output

  def execute(cmd)
    full_cmd = "sshpass -p #{DOMAIN0_PASSWORD} ssh -p #{DOMAIN0_PORT} #{DOMAIN0_USERNAME}@#{DOMAIN0_HOST} '#{cmd}'"
    @output = `#{full_cmd}`.to_s
    $?.to_i
  end
  
  def super_execute(cmd)
    execute(sudo_modify(cmd))
  end
  
private
  # modify command as sudo.
  def sudo_modify(cmd)
    "echo #{DOMAIN0_PASSWORD} | sudo -S #{cmd}"
  end
end

class DomainUCommand < DomainCommand
  # consts
  DOMAINU_USERNAME = 'root'
  DOMAINU_PASSWORD = 'root'
  DOMAINU_HOST_PREFIX = '192.168.2.20'
  
  attr_accessor :index
  attr_reader :output
  
  def initialize(i)
    if i < 1 or i > 9
      fatal "bad domain index #{i}"
    end
    
    @index = i
  end

  def super_execute(cmd)
    full_cmd = "sshpass -p #{DOMAINU_PASSWORD} ssh #{DOMAINU_USERNAME}@#{DOMAINU_HOST_PREFIX}#{@index} '#{cmd}'"
    @output = `#{full_cmd}`.to_s
    $?.to_i
  end
end

class ParameterizedTest
  # consts
  NETPERF_TEST_LENGTH = 35 # seconds
  XENTOP_WAIT_BEFORE = 5 # seconds
  XENTOP_CALL_COUNT = 5 # times
  XENTOP_DELAY = 5 # seconds
  CFG_PREFIX = "/home/snowwolf/TPDS/cfg"
  T_PATTERN = /rx-usecs: ([[:digit:]]+)/
  SETUP_TV = true
  MAX_DOMAIN_COUNT = 10
  
  attr_accessor :test_name

  # input parameters
  attr_accessor :domain_count
  attr_accessor :coalesc_type
  attr_accessor :Tp
  attr_accessor :Tv
  attr_accessor :packet_size
  attr_accessor :protocol_type
  attr_accessor :burst
  
  # output results
  attr_reader :dom_cpu
  attr_reader :total_domu_cpu
  attr_reader :dom_netperf
  attr_reader :total_netperf
  
  def initialize(test_name)
    @test_name = test_name
    @domain_count = 10
    @coalesc_type = :frontend # or :backend or :orig
    @Tp = 18 # default
    @Tv = 1000 # default
    @packet_size = 1500
    @protocol_type = :tcp # or :udp or :tcp_rr or :udp_rr
    @burst = 0 # or 3 (burst)
    
    @dom_cpu = Array.new
    @dom_netperf = Array.new
    
    @dom_cmds = Array.new
    @dom_cmds[0] = Domain0Command.new
    for i in 1...MAX_DOMAIN_COUNT
      @dom_cmds[i] = DomainUCommand.new(i)
    end
    
    # netperf threads.
    @np_threads = Array.new
  end

  def run
    Log.info "===== starting test '#{@test_name}' ====="
  
    # step 1: startup domains.
    start_domains()
    check_domains() if $DEBUG
    
    # step 2: setup Tp.
    setup_Tp()
    check_Tp() if $DEBUG
    
    # step 3: setup Tv.
    if SETUP_TV
      setup_Tv()
    else
      Log.info "Tv setup skipped."
    end
    
    # step 4: run netperf.
    parallel_run_netperf()

    # step 5: run xentop.
    run_xentop()
    
    # step 6: compute netperf result.
    Log.info "netperf info:"
    @total_netperf = 0.0
    for i in 1...@domain_count
      Log.info "    domain #{i}: #{@dom_netperf[i].round(2)}"
      @total_netperf += @dom_netperf[i]
    end
    Log.info "  total: #{@total_netperf.round(2)}"
    
    # step 7: compute cpu.
    Log.info "cpu info:"
    Log.info "  domain 0: #{@dom_cpu[0].round(2)}"
    
    @total_domu_cpu = 0.0
    for i in 1...@domain_count
      Log.info "    domain #{i}: #{@dom_cpu[i].round(2)}"
      @total_domu_cpu += @dom_cpu[i]
    end
    Log.info "  domain U: #{@total_domu_cpu.round(2)}"
    
    Log.info "===== test '#{@test_name}' completed ====="
  end
  
private
  def start_domains
    for i in 1...MAX_DOMAIN_COUNT
      stop_domain(i)
    end
    
    for i in 1...@domain_count
      start_domain(i)
    end
  end
  
  # checking if the current number of domains equals the one expected.
  def check_domains()
    Log.info "[ checking domains... ]"
    
    n = number_of_domains_started()
    if n == @domain_count
      Log.info "[ checking domains ok ]"
    else
      Log.fatal "[ checking domains failed ]"
    end
  end
  
  def start_domain(i)
    Log.info "starting domain #{i}..."
    
    if @coalesc_type == :frontend
      @dom_cmds[0].super_execute("xm create #{CFG_PREFIX}/#{i}.fec.cfg")
    else
      @dom_cmds[0].super_execute("xm create #{CFG_PREFIX}/#{i}.nofec.cfg")
    end
  end
  
  def stop_domain(i)
    Log.info "stopping domain #{i}..."
    
    @dom_cmds[0].super_execute("xm destroy vm#{i}")
  end
  
  def number_of_domains_started
    @dom_cmds[0].super_execute("xm list")
    
    # skip the title line.
    @dom_cmds[0].output.count("\n") - 1
  end
  
  def current_Tp
    @dom_cmds[0].super_execute("ethtool -c peth1")
    @dom_cmds[0].output =~ T_PATTERN
    $1.to_i
  end
  
  def setup_Tp
    Log.info "setting up Tp for domain 0."
    @dom_cmds[0].super_execute("ethtool -C peth1 rx-usecs #{@Tp}")
  end
  
  # checking if the current Tp equals the one expected.
  def check_Tp
    Log.info "[ checking Tp... ]"
    
    if (current_Tp == @Tp)
      Log.info "[ checking Tp ok ]"
    else
      Log.fatal "[ checking Tp failed ]"
    end
  end
  
  def current_Tv_fec(i)
    @dom_cmds[i].super_execute("ethtool -c eth0")
    @dom_cmds[i].output =~ T_PATTERN
    $1.to_i
  end
  
  def set_Tv_fec(i)
    @dom_cmds[i].super_execute("ethtool -C eth0 rx-usecs #{@Tv}")
  end

  # checking if the current Tv of the specified domain equals the one expected.
  def check_Tv_fec(i)
    Log.info "[ checking Tv for domain #{i}... ]"
    
    if (current_Tv_fec(i) == @Tv)
      Log.info "[ checking Tv for domain #{i} ok ]"
    else
      Log.fatal "[ checking Tv for domain #{i} failed ]"
    end
  end
  
  def set_Tv_bec
    @dom_cmds[0].super_execute("echo #{@Tv} > /proc/bec_usecs")
  end

  def setup_Tv
    threads = Array.new
    
    if @coalesc_type == :frontend
      for i in 1...@domain_count
        Log.info "setting up Tv for domain #{i}."
        
        threads << Thread.new(i) do |i|
          set_Tv_fec(i)
          check_Tv_fec(i) if $DEBUG
        end
      end
      
      threads.each { |t| t.join }
    elsif @coalesc_type == :backend
      Log.info "setting up Tv for domain 0."
      set_Tv_bec()
    else @coalesc_type == :orig
      Log.info "Tv setup skipped in original coalescing."
    end
  end
  
  def parallel_run_netperf
    if @protocol_type == :tcp
      type_string = "-t TCP_STREAM"
      burst_string = ""
      packet_string = "-m #{@packet_size}"
    elsif @protocol_type == :udp
      type_string = "-t UDP_STREAM"
      burst_string = ""
      packet_string = "-m #{@packet_size}"
    elsif @protocol_type == :tcp_rr
      type_string = "-t TCP_RR"
      burst_string = "-b #{@burst}"
      packet_string = ""
    else # udp_rr
      type_string = "-t UDP_RR"
      burst_string = "-b #{@burst}"
      packet_string = ""
    end
    
    outputs = Array.new
    for i in 1...@domain_count
      Log.info "starting netperf for domain #{i}."
      
      full_cmd = "netperf -H 192.168.2.20#{i} #{type_string} -l #{NETPERF_TEST_LENGTH} -- -S 1000000 -s 1000000 #{burst_string} #{packet_string}"

      @np_threads << Thread.new(i) do |i|
        outputs[i] = `#{full_cmd}`
        if @protocol_type == :tcp
          # bandwidth is in the 5th column of the 7th line.
          target_line = 6
          target_column = 4
        elsif @protocol_type == :udp
          # bandwidth is in the 5th column of the 7th line.
          target_line = 6
          target_column = 3
        else
          # tps is in the 6th column of the 7th line.
          target_line = 6
          target_column = 5
        end
        Log.info outputs[i], target_line, target_column
        @dom_netperf[i] = outputs[i].split(/\n/)[target_line].split(/\s+/)[target_column].to_f;
      end
    end
  end
  
  def run_xentop
    Log.info "waiting for cpu util to be stable."
    sleep(XENTOP_WAIT_BEFORE)
    
    # init dom_cpu to zero.
    @domain_count.times { |i| @dom_cpu[i] = 0.0 }
    
    # repeat XENTOP_CALL_COUNT times calling xentop.
    XENTOP_CALL_COUNT.times do |k|
      Log.info "xentop iteration #{k + 1} proceeding..."
      
      @dom_cmds[0].super_execute("xentop -b -i2 -d#{XENTOP_DELAY}")
      lines = @dom_cmds[0].output.split(/\n/)
      
      # identify the cpu util of each domain from its corresponding line
      # in the output of the xentop.
      start = @domain_count + 2
      stop = start + @domain_count
      di = 0
      for li in start...stop
        cpu = lines[li].split(/\s+/)[4].to_f
      # in the output of the xentop.
        @dom_cpu[di] += cpu
        di += 1
      end
    end
    
    # gain average for each domain.
    @domain_count.times { |i| @dom_cpu[i] /= XENTOP_CALL_COUNT }
    
    Log.info "waiting for netperf to terminate."
    @np_threads.each { |t| t.join }
    @np_threads.clear
  end
end

class TestSuite
  TEST_SEPARATER = "========================================"

  attr_accessor :test_descs
  attr_accessor :suite_name
  
  def initialize(suite_name)
    @suite_name = suite_name
    @test_descs = Array.new
  end
  
  def run(i)
    File.open("#{@suite_name}_#{Time.now.strftime("%Y_%m_%d_%H_%M_%S")}", "w") do |file|
      file.puts TEST_SEPARATER
      file.puts "== test_suite_name:\t#{@suite_name}"
      file.puts "== test_count:\t\t#{test_descs.length}"
      file.puts TEST_SEPARATER
      file.flush
      
      while i < test_descs.length
        test = parse_test(test_descs[i])
        
        file.puts "== test_id:\t\t#{i}"
        file.puts "== test_name:\t\t#{test.test_name}"
        file.puts "== domain_count:\t#{test.domain_count}"
        file.puts "== coalesc_type:\t#{test.coalesc_type}"
        file.puts "== Tp:\t\t\t#{test.Tp}"
        file.puts "== Tv:\t\t\t#{test.Tv}"
        file.puts "== packet_size:\t\t#{test.packet_size}"
        file.puts "== protocol_type:\t#{test.protocol_type}"
        file.puts "== burst:\t\t#{test.burst}"
        file.puts "=="
        file.puts "== results:"
        file.flush
        
        test.run()
        
        file.puts "==   cpu:"
        file.puts "==     dom0:\t\t#{test.dom_cpu[0].round(2)}"
        file.puts "==     domU:\t\t#{test.total_domu_cpu.round(2)}"
        file.puts "==   netperf:\t\t#{test.total_netperf.round(2)}"
        file.puts TEST_SEPARATER
        file.flush
        
        i += 1

        File.open("test_status", "w") do |status|
          status.puts "#{@suite_name} #{i}"
        end
      end
    end
  end
 
private
  def parse_test(test_desc)
    test = ParameterizedTest.new(test_desc[0])
    test.domain_count = test_desc[1]
    test.coalesc_type = test_desc[2]
    test.Tp = test_desc[3]
    test.Tv = test_desc[4]
    test.packet_size = test_desc[5]
    test.protocol_type = test_desc[6]
    test.burst = test_desc[7]
    test
  end
end

# test_name domain_count coalesc_type Tp Tv packet_size protocol_type burst
t1 = TestSuite.new("orig_or_frontend")
t1.test_descs \
  << ["6.1", 1 + 1, :orig, 18, 1000, 50, :udp, 0] \
  << ["6.3", 1 + 1, :frontend, 18, 1000, 50, :udp, 0] \
  << ["9.1", 1 + 1, :orig, 18, 1000, 50, :tcp, 0] \
  << ["9.3", 1 + 1, :frontend, 18, 1000, 50, :tcp, 0] \
  << ["8.1", 1 + 1, :orig, 18, 1000, 1500, :udp, 0] \
  << ["8.3", 1 + 1, :frontend, 18, 1000, 1500, :udp, 0] \
  << ["10.1", 1 + 1, :orig, 18, 1000, 1500, :tcp, 0] \
  << ["10.3", 1 + 1, :frontend, 18, 1000, 1500, :tcp, 0] \
  << ["11.1", 1 + 1, :orig, 18, 1000, 1500, :udp, 0] \
  << ["11.3", 1 + 1, :frontend, 18, 1000, 1500, :udp, 0] \
  << ["11.4", 1 + 3, :orig, 18, 1000, 1500, :udp, 0] \
  << ["11.6", 1 + 3, :frontend, 18, 1000, 1500, :udp, 0] \
  << ["11.7", 1 + 6, :orig, 18, 1000, 1500, :udp, 0] \
  << ["11.9", 1 + 6, :frontend, 18, 1000, 1500, :udp, 0] \
  << ["11.10", 1 + 9, :orig, 18, 1000, 1500, :udp, 0] \
  << ["11.12", 1 + 9, :frontend, 18, 1000, 1500, :udp, 0] \
  << ["12.1", 1 + 1, :orig, 18, 1000, 1500, :tcp, 0] \
  << ["12.3", 1 + 1, :frontend, 18, 1000, 1500, :tcp, 0] \
  << ["12.4", 1 + 3, :orig, 18, 1000, 1500, :tcp, 0] \
  << ["12.6", 1 + 3, :frontend, 18, 1000, 1500, :tcp, 0] \
  << ["12.7", 1 + 6, :orig, 18, 1000, 1500, :tcp, 0] \
  << ["12.9", 1 + 6, :frontend, 18, 1000, 1500, :tcp, 0] \
  << ["12.10", 1 + 9, :orig, 18, 1000, 1500, :tcp, 0] \
  << ["12.12", 1 + 9, :frontend, 18, 1000, 1500, :tcp, 0] \
  << ["13.1", 1 + 1, :frontend, 18, 200, 1500, :tcp, 0] \
  << ["13.2", 1 + 1, :frontend, 18, 500, 1500, :tcp, 0] \
  << ["13.3", 1 + 1, :frontend, 18, 1000, 1500, :tcp, 0] \
  << ["13.4", 1 + 1, :frontend, 18, 1250, 1500, :tcp, 0] \
  << ["13.5", 1 + 1, :frontend, 18, 2000, 1500, :tcp, 0] \
  << ["13.6", 1 + 1, :orig, 18, 1000, 1500, :tcp, 0] \
  << ["14.1", 1 + 1, :frontend, 18, 200, 1500, :udp, 0] \
  << ["14.2", 1 + 1, :frontend, 18, 500, 1500, :udp, 0] \
  << ["14.3", 1 + 1, :frontend, 18, 1000, 1500, :udp, 0] \
  << ["14.4", 1 + 1, :frontend, 18, 1250, 1500, :udp, 0] \
  << ["14.5", 1 + 1, :frontend, 18, 2000, 1500, :udp, 0] \
  << ["14.6", 1 + 1, :orig, 18, 1000, 1500, :udp, 0] \
  << ["15.1", 1 + 1, :frontend, 1000, 250, 1500, :tcp, 0] \
  << ["15.2", 1 + 1, :frontend, 750, 500, 1500, :tcp, 0] \
  << ["15.3", 1 + 1, :frontend, 500, 750, 1500, :tcp, 0] \
  << ["15.4", 1 + 1, :frontend, 250, 1000, 1500, :tcp, 0] \
  << ["16.1", 1 + 3, :frontend, 1000, 250, 1500, :tcp, 0] \
  << ["16.2", 1 + 3, :frontend, 750, 500, 1500, :tcp, 0] \
  << ["16.3", 1 + 3, :frontend, 500, 750, 1500, :tcp, 0] \
  << ["16.4", 1 + 3, :frontend, 250, 1000, 1500, :tcp, 0] \
  << ["17.1", 1 + 6, :frontend, 1000, 250, 1500, :tcp, 0] \
  << ["17.2", 1 + 6, :frontend, 750, 500, 1500, :tcp, 0] \
  << ["17.3", 1 + 6, :frontend, 500, 750, 1500, :tcp, 0] \
  << ["17.4", 1 + 6, :frontend, 250, 1000, 1500, :tcp, 0] \
  << ["18.1", 1 + 9, :frontend, 1000, 250, 1500, :tcp, 0] \
  << ["18.2", 1 + 9, :frontend, 750, 500, 1500, :tcp, 0] \
  << ["18.3", 1 + 9, :frontend, 500, 750, 1500, :tcp, 0] \
  << ["18.4", 1 + 9, :frontend, 250, 1000, 1500, :tcp, 0]
  
t2 = TestSuite.new("backend")
t2.test_descs \
  << ["6.2", 1 + 1, :backend, 18, 1000, 50, :udp, 0] \
  << ["9.2", 1 + 1, :backend, 18, 1000, 50, :tcp, 0] \
  << ["8.2", 1 + 1, :backend, 18, 1000, 1500, :udp, 0] \
  << ["10.2", 1 + 1, :backend, 18, 1000, 1500, :tcp, 0] \
  << ["11.2", 1 + 1, :backend, 18, 1000, 1500, :udp, 0] \
  << ["11.5", 1 + 3, :backend, 18, 1000, 1500, :udp, 0] \
  << ["11.8", 1 + 6, :backend, 18, 1000, 1500, :udp, 0] \
  << ["11.11", 1 + 9, :backend, 18, 1000, 1500, :udp, 0] \
  << ["12.2", 1 + 1, :backend, 18, 1000, 1500, :tcp, 0] \
  << ["12.5", 1 + 3, :backend, 18, 1000, 1500, :tcp, 0] \
  << ["12.8", 1 + 6, :backend, 18, 1000, 1500, :tcp, 0] \
  << ["12.11", 1 + 9, :backend, 18, 1000, 1500, :tcp, 0]

if !File.exist?("test_status")
  `echo "orig_or_frontend 0" > test_status`
end

File.open("test_status", "r") do |status|
  x = status.gets.split(/\s/)
  a = x[0]
  b = x[1].to_i
  if a == "orig_or_frontend"
    t1.run(b)
  elsif a == "backend"
    t2.run(b)
  end
end

