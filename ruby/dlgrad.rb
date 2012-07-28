class DLGrader
  def initialize(base_dir, source_dir, verbose)
    @base_dir, @source_dir, @verbose = base_dir, source_dir, verbose
  end
  
  def grade_all
    Dir.foreach(@base_dir) do |sub_dir_name|
      grade sub_dir_name if sub_dir_name != "." and sub_dir_name != ".." and sub_dir_name != ".svn" 
    end
  end
  
  def grade(sub_dir_name)
    number = sub_dir_name[3...sub_dir_name.length].center(10)
     
    # 1. generate zapped bits.c from source bits.c
    `#{@source_dir}/dlc 2>/dev/null -z -o #{@source_dir}/bits.c #{@base_dir}/#{sub_dir_name}/lab1/bits.c`
    return error(number, "dlc error") if $? != 0
   
    # 2. make the project
    `cd #{@source_dir} && make 2>/dev/null`
    return error(number, "compile error") if $? != 0
    
    # 3. stat basic grade of each function
    funs = Hash.new
    `#{@source_dir}/btest`.scan(/Test (\w+) score: (\d.\d\d)/) do |match|
      funs[match[0]] = { basic: Float(match[1]), perf: 0.0 }
    end
    return error(number, "info missing") if $? != 0
    
    # 4. stat performance grade of each function
    `#{@source_dir}/dlc 2>/dev/null -e #{@source_dir}/bits.c`.split(/\n/).each do |line|
      fields = line.split(/:/)
      fun, opers = fields[3], fields[4]
      funs[fun][:perf] = 2.0 if funs[fun][:basic] > 0.0 and opers != " Warning"
    end

    # 5. sum up and output
    basic = perf = 0.0
    funs.each do |key, value|
      basic += value[:basic]
      perf += value[:perf]
    end
    total = basic + perf
    puts @verbose ? "number: #{number}, total: #{total} (#{basic} + #{perf})" : "#{number}, #{total}"
  end
  
private
  def error(number, msg)
    puts @verbose ? "number: #{number}, total:  0.0 (#{msg})" : "#{number},  0.0"
  end
end

DLGrader.new("/home/lewis/ics-se11", "/home/lewis/lab1", ARGV[0] == "-v").grade_all
