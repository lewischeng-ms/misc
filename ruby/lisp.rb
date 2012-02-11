class TinyLisp
  def initialize
    @proctab = {
      # for all the procedures below, args[0] is the procedure name
      
      geq?: lambda { |args| exec(args[1]) >= exec(args[2]) },
      leq?: lambda { |args| exec(args[1]) <= exec(args[2]) },
      eq?: lambda { |args| exec(args[1]) == exec(args[2]) },
      add: lambda { |args| exec(args[1]) + exec(args[2]) },
      mul: lambda { |args| exec(args[1]) * exec(args[2]) },
      sub: lambda { |args| exec(args[1]) - exec(args[2]) },
      
      # [:defun, name, [arg1, arg2, ...] [body]]
      defun: lambda do |args|
        # args[1] = procedure name
        # args[2..3] = params and body
        @proctab[args[1]] = args[2..3]
        "<proc: #{args[1]}>"
      end,
      
      # [:setq, name, obj]
      setq: lambda do |args|
        @frames.last[args[1]] = exec(args[2])
      end,
      
      # [:if, cond, branch_true, branch_false]
      if: lambda do |args|
        if exec(args[1]) # condition
          exec(args[2]) # branch_true
        else
          exec(args[3]) # branch_false
        end
      end,
      
      # [:do, [var, init, inc], [cond], [body]]
      do: lambda do |args|
        @frames.push Hash.new
        
        # add loop variable
        do_decl = args[1] # args[1] = [var, init, inc]
        @frames.last[do_decl[0]] = do_decl[1]
        
        until exec args[2] # args[2] = cond
          result = exec_body args[3] # args[3] = body
          @frames.last[do_decl[0]] = exec do_decl[2]
        end
        
        @frames.pop
        result
      end,
      
      # [:let, [[var1, init1], [var2, init2], ...], [body]]
      let: lambda do |args|
        @frames.push Hash.new
        
        # add local variables
        args[1].each { |pair| @frames.last[pair[0]] = pair[1] }
        
        result = exec_body args[2] # body
        
        @frames.pop
        result
      end,
      
      # proxy for calling user-defined procedures
      proxy: lambda do |params_and_body, args|
        @frames.push Hash.new
        
        # add arguments
        params = params_and_body[0] # params
        params.length.times { |i| @frames.last[params[i]] = exec(args[i + 1]) }
        
        result = exec_body params_and_body[1] # body
        
        @frames.pop
        result
      end
    }

    # calling stack
    @frames = [{}]
  end
  
  def exec(list)
    # return what it is if not a list
    if list.class != Array
      if list.class == Symbol
        @frames.reverse_each { |frame| return frame[list] if frame[list] }
        puts "symbol #{list} undefined"
        return nil
      else
        return list
      end
    end
    
    first = list[0]
    # error if not a procedure
    if first.class != Symbol
      puts "#{first} not a procedure"
      return nil
    end
    
    proc = @proctab[first]
    # error if not defined
    if proc == nil
      puts "procedure #{first} undefined"
    end
    
    if proc.class == Proc
      # call the predefined procedure
      return proc.call list
    else
      # it's a user-defined procedure
      params_and_body = proc
      proc = @proctab[:proxy]
      return proc.call params_and_body, list
    end
  end
  
  def exec_body(body)
    result = nil
    body.each { |list| result = exec list }
    result
  end
  
  def run(list_of_lists)
    exec_body(list_of_lists)
  end
end

require 'test/unit'
class TestTinyLisp < Test::Unit::TestCase
  def initialize(name)
    super(name)
    @lisp = TinyLisp.new
  end
  
  # recursive Fibonacci sequence
  def test_fib
    result = @lisp.run([[:defun, :Fib, [:N],
                                 [[:if, [:leq?, :N, 0],
                                        0,
                                        [:if, [:eq?, :N, 1],
                                              1,
                                              [:add, [:Fib, [:sub, :N, 1]],
                                                     [:Fib, [:sub, :N, 2]]]]]]],
                        [:Fib, 25]])
    assert_equal(result, 75025)
  end
  
  # iterative Fibonacci sequence
  def test_fibo
    result = @lisp.run([[:defun, :Fibo, [:N],
                                 [[:let, [[:A, 0], [:B, 1], [:TEMP, 0]],
                                         [[:if, [:leq?, :N, 0],
                                               :A,
                                               [:if, [:eq?, :N, 1],
                                                     :B,
                                                     [:do, [:I, 0, [:add, :I, 1]],
                                                           [:geq?, :I, :N],
                                                           [[:setq, :TEMP, [:add, :A, :B]],
                                                            [:setq, :A, :B],
                                                            [:setq, :B, :TEMP],
                                                            :A]]]]]]]],
                        [:Fibo, 25]]);
    assert_equal(result, 75025)
  end

  # recursive factorial
  def test_fact
    result = @lisp.run([[:defun, :Fact, [:N],
                                 [[:if, [:leq?, :N, 1],
                                        1,
                                        [:mul, :N, [:Fact, [:sub, :N, 1]]]]]],
                        [:Fact, 10]])
    assert_equal(result, 3628800)
  end
end

