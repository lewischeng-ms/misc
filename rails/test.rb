Last login: Tue Feb  7 12:50:10 on console
➜  ~ cd GitHub
➜  GitHub ls
Dash-iOS            DependencyInjection misc                touchbar_nyancat
➜  GitHub cd misc
➜  misc git:(master) ls
README.md  cpp        php        racket     ruby
Sample.md  csharp     powershell rails      sql
c          java       python     raspberry  ssis
➜  misc git:(master) cd rails
➜  rails git:(master) ls
hello_app  sample_app toy_app
➜  rails git:(master) gst
On branch master
Your branch is up-to-date with 'origin/master'.
nothing to commit, working tree clean
➜  rails git:(master) cd sample_app
➜  sample_app git:(master) rails console
/usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/xml_mini.rb:51: warning: constant ::Fixnum is deprecated
/usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/xml_mini.rb:52: warning: constant ::Bignum is deprecated
/usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/core_ext/numeric/conversions.rb:138: warning: constant ::Fixnum is deprecated
Running via Spring preloader in process 1384
Loading development environment (Rails 5.0.1)
>> nil.to_s
=> ""
>> nil.empty?
NoMethodError: undefined method `empty?' for nil:NilClass
  from (irb):2
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> nil.to_s.empty?
=> true
>> false.nil?
=> false
>> true.nil?
=> false
>> "foo".nil?
=> false
>> nil.nil?
=> true
>> ss="foo"
=> "foo"
>> puts "abc" unless ss.include?("foo")
=> nil
>> puts "abc" unless ss.include?("foo1")
abc
=> nil
>> !nil
=> true
>> !!nil
=> false
>> !!0
=> true
>> !nil
=> true
>> !0
=> false
>> "racecar".nil?
=> false
>> "racecar".length
=> 7
>> "abc".reverse
=> "cba"
>> s="cbc"
=> "cbc"
>> s==s.reverse
=> true
>> s.reverse!
=> "cbc"
>> s
=> "cbc"
>> s="abc"
=> "abc"
>> s.reverse!
=> "cba"
>> s
=> "cba"
>> def foo
>> puts "hello"
>> end
=> :foo
>> :foo
=> :foo
>> foo
hello
=> nil
>> def test(s)
>> if s==s.reverse
>> puts "it's a palindrome!"
>> else
?> puts "it's not a palindrome!"
>> end
>> end
=> :test
>> test("abc")
it's not a palindrome!
=> nil
>> test("aba")
it's a palindrome!
=> nil
>> ["a","b","c"]
=> ["a", "b", "c"]
>> "fooxbarxbaz".split('x')
=> ["foo", "bar", "baz"]
>> a=[42,8,17]
=> [42, 8, 17]
>> a[0]
=> 42
>> a[2]
=> 17
>> a[-1]
=> 17
>> a[-2]
=> 8
>> a[-3]
=> 42
>> a[-4]
=> nil
>> a.first
=> 42
>> a.second
=> 8
>> a.third
=> 17
>> a.fourth
=> nil
>> a+=7
TypeError: no implicit conversion of Integer into Array
  from (irb):53:in `+'
  from (irb):53
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> a=a+[7]
=> [42, 8, 17, 7]
>> a.fourth
=> 7
>> a.sixth
NoMethodError: undefined method `sixth' for [42, 8, 17, 7]:Array
  from (irb):56
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> a.fifth
=> nil
>> a.sixth
NoMethodError: undefined method `sixth' for [42, 8, 17, 7]:Array
  from (irb):58
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> a.last
=> 7
>> a.lasttwo
NoMethodError: undefined method `lasttwo' for [42, 8, 17, 7]:Array
Did you mean?  last
  from (irb):60
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> a.lastsecond
NoMethodError: undefined method `lastsecond' for [42, 8, 17, 7]:Array
Did you mean?  second
  from (irb):61
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> a.last==a[-1]
=> true
>> a.sort
=> [7, 8, 17, 42]
>> a.reverse
=> [7, 17, 8, 42]
>> a.shuffle
=> [7, 8, 17, 42]
>> a.shuffle
=> [8, 7, 17, 42]
>> a.shuffle
=> [8, 17, 7, 42]
>>
?> a.shuffle
=> [17, 8, 7, 42]
>> a
=> [42, 8, 17, 7]
>> a.sort!
=> [7, 8, 17, 42]
>> a
=> [7, 8, 17, 42]
>> a.push 9
=> [7, 8, 17, 42, 9]
>> a << 9
=> [7, 8, 17, 42, 9, 9]
>> a << 11
=> [7, 8, 17, 42, 9, 9, 11]
>> a << "abc"
=> [7, 8, 17, 42, 9, 9, 11, "abc"]
>> a.join
=> "7817429911abc"
>> a.join!
NoMethodError: undefined method `join!' for [7, 8, 17, 42, 9, 9, 11, "abc"]:Array
Did you mean?  join
  from (irb):78
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> a.join
=> "7817429911abc"
>> a.join(',')
=> "7,8,17,42,9,9,11,abc"
>> 0..9
=> 0..9
>> 0...9
=> 0...9
>> 0....9
SyntaxError: (irb):83: no .<digit> floating literal anymore; put 0 before dot
0....9
     ^
(irb):83: syntax error, unexpected '.'
0....9
     ^
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> (0..9).to_s
=> "0..9"
>> (0..9).to_a
=> [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
>> (0...9).to_a
=> [0, 1, 2, 3, 4, 5, 6, 7, 8]
>> a
=> [7, 8, 17, 42, 9, 9, 11, "abc"]
>> a[1..2]
=> [8, 17]
>> a[1..3]
=> [8, 17, 42]
>> a=%w[abc,bcd,cde]
=> ["abc,bcd,cde"]
>> a=%w[abc bcd cde]
=> ["abc", "bcd", "cde"]
>> a[2..(a.length-1)]
=> ["cde"]
>> a[1..(a.length-1)]
=> ["bcd", "cde"]
>> a[1..-2]
=> ["bcd"]
>> a[0..-2]
=> ["abc", "bcd"]
>> a[2..-2]
=> []
>> a[2..-1]
=> ["cde"]
>> ('a'..'z').to_a
=> ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
>> ('a'..'Z').to_a
=> []
>> ('A'..'Z').to_a
=> ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
>> ('A'..'a').to_a
=> ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "[", "\\", "]", "^", "_", "`", "a"]
>> ('abc'..'cde').to_a
=> ["abc", "abd", "abe", "abf", "abg", "abh", "abi", "abj", "abk", "abl", "abm", "abn", "abo", "abp", "abq", "abr", "abs", "abt", "abu", "abv", "abw", "abx", "aby", "abz", "aca", "acb", "acc", "acd", "ace", "acf", "acg", "ach", "aci", "acj", "ack", "acl", "acm", "acn", "aco", "acp", "acq", "acr", "acs", "act", "acu", "acv", "acw", "acx", "acy", "acz", "ada", "adb", "adc", "add", "ade", "adf", "adg", "adh", "adi", "adj", "adk", "adl", "adm", "adn", "ado", "adp", "adq", "adr", "ads", "adt", "adu", "adv", "adw", "adx", "ady", "adz", "aea", "aeb", "aec", "aed", "aee", "aef", "aeg", "aeh", "aei", "aej", "aek", "ael", "aem", "aen", "aeo", "aep", "aeq", "aer", "aes", "aet", "aeu", "aev", "aew", "aex", "aey", "aez", "afa", "afb", "afc", "afd", "afe", "aff", "afg", "afh", "afi", "afj", "afk", "afl", "afm", "afn", "afo", "afp", "afq", "afr", "afs", "aft", "afu", "afv", "afw", "afx", "afy", "afz", "aga", "agb", "agc", "agd", "age", "agf", "agg", "agh", "agi", "agj", "agk", "agl", "agm", "agn", "ago", "agp", "agq", "agr", "ags", "agt", "agu", "agv", "agw", "agx", "agy", "agz", "aha", "ahb", "ahc", "ahd", "ahe", "ahf", "ahg", "ahh", "ahi", "ahj", "ahk", "ahl", "ahm", "ahn", "aho", "ahp", "ahq", "ahr", "ahs", "aht", "ahu", "ahv", "ahw", "ahx", "ahy", "ahz", "aia", "aib", "aic", "aid", "aie", "aif", "aig", "aih", "aii", "aij", "aik", "ail", "aim", "ain", "aio", "aip", "aiq", "air", "ais", "ait", "aiu", "aiv", "aiw", "aix", "aiy", "aiz", "aja", "ajb", "ajc", "ajd", "aje", "ajf", "ajg", "ajh", "aji", "ajj", "ajk", "ajl", "ajm", "ajn", "ajo", "ajp", "ajq", "ajr", "ajs", "ajt", "aju", "ajv", "ajw", "ajx", "ajy", "ajz", "aka", "akb", "akc", "akd", "ake", "akf", "akg", "akh", "aki", "akj", "akk", "akl", "akm", "akn", "ako", "akp", "akq", "akr", "aks", "akt", "aku", "akv", "akw", "akx", "aky", "akz", "ala", "alb", "alc", "ald", "ale", "alf", "alg", "alh", "ali", "alj", "alk", "all", "alm", "aln", "alo", "alp", "alq", "alr", "als", "alt", "alu", "alv", "alw", "alx", "aly", "alz", "ama", "amb", "amc", "amd", "ame", "amf", "amg", "amh", "ami", "amj", "amk", "aml", "amm", "amn", "amo", "amp", "amq", "amr", "ams", "amt", "amu", "amv", "amw", "amx", "amy", "amz", "ana", "anb", "anc", "and", "ane", "anf", "ang", "anh", "ani", "anj", "ank", "anl", "anm", "ann", "ano", "anp", "anq", "anr", "ans", "ant", "anu", "anv", "anw", "anx", "any", "anz", "aoa", "aob", "aoc", "aod", "aoe", "aof", "aog", "aoh", "aoi", "aoj", "aok", "aol", "aom", "aon", "aoo", "aop", "aoq", "aor", "aos", "aot", "aou", "aov", "aow", "aox", "aoy", "aoz", "apa", "apb", "apc", "apd", "ape", "apf", "apg", "aph", "api", "apj", "apk", "apl", "apm", "apn", "apo", "app", "apq", "apr", "aps", "apt", "apu", "apv", "apw", "apx", "apy", "apz", "aqa", "aqb", "aqc", "aqd", "aqe", "aqf", "aqg", "aqh", "aqi", "aqj", "aqk", "aql", "aqm", "aqn", "aqo", "aqp", "aqq", "aqr", "aqs", "aqt", "aqu", "aqv", "aqw", "aqx", "aqy", "aqz", "ara", "arb", "arc", "ard", "are", "arf", "arg", "arh", "ari", "arj", "ark", "arl", "arm", "arn", "aro", "arp", "arq", "arr", "ars", "art", "aru", "arv", "arw", "arx", "ary", "arz", "asa", "asb", "asc", "asd", "ase", "asf", "asg", "ash", "asi", "asj", "ask", "asl", "asm", "asn", "aso", "asp", "asq", "asr", "ass", "ast", "asu", "asv", "asw", "asx", "asy", "asz", "ata", "atb", "atc", "atd", "ate", "atf", "atg", "ath", "ati", "atj", "atk", "atl", "atm", "atn", "ato", "atp", "atq", "atr", "ats", "att", "atu", "atv", "atw", "atx", "aty", "atz", "aua", "aub", "auc", "aud", "aue", "auf", "aug", "auh", "aui", "auj", "auk", "aul", "aum", "aun", "auo", "aup", "auq", "aur", "aus", "aut", "auu", "auv", "auw", "aux", "auy", "auz", "ava", "avb", "avc", "avd", "ave", "avf", "avg", "avh", "avi", "avj", "avk", "avl", "avm", "avn", "avo", "avp", "avq", "avr", "avs", "avt", "avu", "avv", "avw", "avx", "avy", "avz", "awa", "awb", "awc", "awd", "awe", "awf", "awg", "awh", "awi", "awj", "awk", "awl", "awm", "awn", "awo", "awp", "awq", "awr", "aws", "awt", "awu", "awv", "aww", "awx", "awy", "awz", "axa", "axb", "axc", "axd", "axe", "axf", "axg", "axh", "axi", "axj", "axk", "axl", "axm", "axn", "axo", "axp", "axq", "axr", "axs", "axt", "axu", "axv", "axw", "axx", "axy", "axz", "aya", "ayb", "ayc", "ayd", "aye", "ayf", "ayg", "ayh", "ayi", "ayj", "ayk", "ayl", "aym", "ayn", "ayo", "ayp", "ayq", "ayr", "ays", "ayt", "ayu", "ayv", "ayw", "ayx", "ayy", "ayz", "aza", "azb", "azc", "azd", "aze", "azf", "azg", "azh", "azi", "azj", "azk", "azl", "azm", "azn", "azo", "azp", "azq", "azr", "azs", "azt", "azu", "azv", "azw", "azx", "azy", "azz", "baa", "bab", "bac", "bad", "bae", "baf", "bag", "bah", "bai", "baj", "bak", "bal", "bam", "ban", "bao", "bap", "baq", "bar", "bas", "bat", "bau", "bav", "baw", "bax", "bay", "baz", "bba", "bbb", "bbc", "bbd", "bbe", "bbf", "bbg", "bbh", "bbi", "bbj", "bbk", "bbl", "bbm", "bbn", "bbo", "bbp", "bbq", "bbr", "bbs", "bbt", "bbu", "bbv", "bbw", "bbx", "bby", "bbz", "bca", "bcb", "bcc", "bcd", "bce", "bcf", "bcg", "bch", "bci", "bcj", "bck", "bcl", "bcm", "bcn", "bco", "bcp", "bcq", "bcr", "bcs", "bct", "bcu", "bcv", "bcw", "bcx", "bcy", "bcz", "bda", "bdb", "bdc", "bdd", "bde", "bdf", "bdg", "bdh", "bdi", "bdj", "bdk", "bdl", "bdm", "bdn", "bdo", "bdp", "bdq", "bdr", "bds", "bdt", "bdu", "bdv", "bdw", "bdx", "bdy", "bdz", "bea", "beb", "bec", "bed", "bee", "bef", "beg", "beh", "bei", "bej", "bek", "bel", "bem", "ben", "beo", "bep", "beq", "ber", "bes", "bet", "beu", "bev", "bew", "bex", "bey", "bez", "bfa", "bfb", "bfc", "bfd", "bfe", "bff", "bfg", "bfh", "bfi", "bfj", "bfk", "bfl", "bfm", "bfn", "bfo", "bfp", "bfq", "bfr", "bfs", "bft", "bfu", "bfv", "bfw", "bfx", "bfy", "bfz", "bga", "bgb", "bgc", "bgd", "bge", "bgf", "bgg", "bgh", "bgi", "bgj", "bgk", "bgl", "bgm", "bgn", "bgo", "bgp", "bgq", "bgr", "bgs", "bgt", "bgu", "bgv", "bgw", "bgx", "bgy", "bgz", "bha", "bhb", "bhc", "bhd", "bhe", "bhf", "bhg", "bhh", "bhi", "bhj", "bhk", "bhl", "bhm", "bhn", "bho", "bhp", "bhq", "bhr", "bhs", "bht", "bhu", "bhv", "bhw", "bhx", "bhy", "bhz", "bia", "bib", "bic", "bid", "bie", "bif", "big", "bih", "bii", "bij", "bik", "bil", "bim", "bin", "bio", "bip", "biq", "bir", "bis", "bit", "biu", "biv", "biw", "bix", "biy", "biz", "bja", "bjb", "bjc", "bjd", "bje", "bjf", "bjg", "bjh", "bji", "bjj", "bjk", "bjl", "bjm", "bjn", "bjo", "bjp", "bjq", "bjr", "bjs", "bjt", "bju", "bjv", "bjw", "bjx", "bjy", "bjz", "bka", "bkb", "bkc", "bkd", "bke", "bkf", "bkg", "bkh", "bki", "bkj", "bkk", "bkl", "bkm", "bkn", "bko", "bkp", "bkq", "bkr", "bks", "bkt", "bku", "bkv", "bkw", "bkx", "bky", "bkz", "bla", "blb", "blc", "bld", "ble", "blf", "blg", "blh", "bli", "blj", "blk", "bll", "blm", "bln", "blo", "blp", "blq", "blr", "bls", "blt", "blu", "blv", "blw", "blx", "bly", "blz", "bma", "bmb", "bmc", "bmd", "bme", "bmf", "bmg", "bmh", "bmi", "bmj", "bmk", "bml", "bmm", "bmn", "bmo", "bmp", "bmq", "bmr", "bms", "bmt", "bmu", "bmv", "bmw", "bmx", "bmy", "bmz", "bna", "bnb", "bnc", "bnd", "bne", "bnf", "bng", "bnh", "bni", "bnj", "bnk", "bnl", "bnm", "bnn", "bno", "bnp", "bnq", "bnr", "bns", "bnt", "bnu", "bnv", "bnw", "bnx", "bny", "bnz", "boa", "bob", "boc", "bod", "boe", "bof", "bog", "boh", "boi", "boj", "bok", "bol", "bom", "bon", "boo", "bop", "boq", "bor", "bos", "bot", "bou", "bov", "bow", "box", "boy", "boz", "bpa", "bpb", "bpc", "bpd", "bpe", "bpf", "bpg", "bph", "bpi", "bpj", "bpk", "bpl", "bpm", "bpn", "bpo", "bpp", "bpq", "bpr", "bps", "bpt", "bpu", "bpv", "bpw", "bpx", "bpy", "bpz", "bqa", "bqb", "bqc", "bqd", "bqe", "bqf", "bqg", "bqh", "bqi", "bqj", "bqk", "bql", "bqm", "bqn", "bqo", "bqp", "bqq", "bqr", "bqs", "bqt", "bqu", "bqv", "bqw", "bqx", "bqy", "bqz", "bra", "brb", "brc", "brd", "bre", "brf", "brg", "brh", "bri", "brj", "brk", "brl", "brm", "brn", "bro", "brp", "brq", "brr", "brs", "brt", "bru", "brv", "brw", "brx", "bry", "brz", "bsa", "bsb", "bsc", "bsd", "bse", "bsf", "bsg", "bsh", "bsi", "bsj", "bsk", "bsl", "bsm", "bsn", "bso", "bsp", "bsq", "bsr", "bss", "bst", "bsu", "bsv", "bsw", "bsx", "bsy", "bsz", "bta", "btb", "btc", "btd", "bte", "btf", "btg", "bth", "bti", "btj", "btk", "btl", "btm", "btn", "bto", "btp", "btq", "btr", "bts", "btt", "btu", "btv", "btw", "btx", "bty", "btz", "bua", "bub", "buc", "bud", "bue", "buf", "bug", "buh", "bui", "buj", "buk", "bul", "bum", "bun", "buo", "bup", "buq", "bur", "bus", "but", "buu", "buv", "buw", "bux", "buy", "buz", "bva", "bvb", "bvc", "bvd", "bve", "bvf", "bvg", "bvh", "bvi", "bvj", "bvk", "bvl", "bvm", "bvn", "bvo", "bvp", "bvq", "bvr", "bvs", "bvt", "bvu", "bvv", "bvw", "bvx", "bvy", "bvz", "bwa", "bwb", "bwc", "bwd", "bwe", "bwf", "bwg", "bwh", "bwi", "bwj", "bwk", "bwl", "bwm", "bwn", "bwo", "bwp", "bwq", "bwr", "bws", "bwt", "bwu", "bwv", "bww", "bwx", "bwy", "bwz", "bxa", "bxb", "bxc", "bxd", "bxe", "bxf", "bxg", "bxh", "bxi", "bxj", "bxk", "bxl", "bxm", "bxn", "bxo", "bxp", "bxq", "bxr", "bxs", "bxt", "bxu", "bxv", "bxw", "bxx", "bxy", "bxz", "bya", "byb", "byc", "byd", "bye", "byf", "byg", "byh", "byi", "byj", "byk", "byl", "bym", "byn", "byo", "byp", "byq", "byr", "bys", "byt", "byu", "byv", "byw", "byx", "byy", "byz", "bza", "bzb", "bzc", "bzd", "bze", "bzf", "bzg", "bzh", "bzi", "bzj", "bzk", "bzl", "bzm", "bzn", "bzo", "bzp", "bzq", "bzr", "bzs", "bzt", "bzu", "bzv", "bzw", "bzx", "bzy", "bzz", "caa", "cab", "cac", "cad", "cae", "caf", "cag", "cah", "cai", "caj", "cak", "cal", "cam", "can", "cao", "cap", "caq", "car", "cas", "cat", "cau", "cav", "caw", "cax", "cay", "caz", "cba", "cbb", "cbc", "cbd", "cbe", "cbf", "cbg", "cbh", "cbi", "cbj", "cbk", "cbl", "cbm", "cbn", "cbo", "cbp", "cbq", "cbr", "cbs", "cbt", "cbu", "cbv", "cbw", "cbx", "cby", "cbz", "cca", "ccb", "ccc", "ccd", "cce", "ccf", "ccg", "cch", "cci", "ccj", "cck", "ccl", "ccm", "ccn", "cco", "ccp", "ccq", "ccr", "ccs", "cct", "ccu", "ccv", "ccw", "ccx", "ccy", "ccz", "cda", "cdb", "cdc", "cdd", "cde"]
>>
?>
?> "ABCdE".downcase
=> "abcde"
>> ('a'..'z')[7]
NoMethodError: undefined method `[]' for "a".."z":Range
  from (irb):106
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> ('a'..'z').to_a[7]
=> "h"
>> ('z'..'a').to_a[7]
=> nil
>> 9..3
=> 9..3
>> (9..3).to_a
=> []
>> ('a'..'z').to_a[-7]
=> "t"
>> (1..5).each { |i| puts 2*i }
2
4
6
8
10
=> 1..5
>> (1..5).each do |i|
?> puts 2*i
>> end
2
4
6
8
10
=> 1..5
>> (1..5).each do |number|
?> print 2 * number
>> print '-'
>> end
2-4-6-8-10-=> 1..5
>> 3.times { |i| puts i }
0
1
2
=> 3
>> (1..5).map { |i| i**2 }
=> [1, 4, 9, 16, 25]
>> %w[A B C].map{ |c| c.downcase }
=> ["a", "b", "c"]
>> %w[A B C].map{& :downcase }
SyntaxError: (irb):123: syntax error, unexpected &
%w[A B C].map{& :downcase }
               ^
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> %w[A B C].map{&:downcase }
SyntaxError: (irb):124: syntax error, unexpected &
%w[A B C].map{&:downcase }
               ^
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> %w[A B C].map(& :downcase)
=> ["a", "b", "c"]
>> (1..5).each(& :puts)
NoMethodError: private method `puts' called for 1:Integer
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/core_ext/range/each.rb:5:in `each'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/core_ext/range/each.rb:5:in `each'
  from (irb):126
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> (1..5).each(& :to_f)
=> 1..5
>> ('a'..'z').to_a
=> ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
>> ('a'..'z').to_a.shuffle
=> ["d", "s", "p", "b", "f", "w", "c", "e", "q", "m", "x", "i", "t", "v", "o", "h", "u", "n", "y", "z", "g", "a", "l", "k", "r", "j"]
>> ('a'..'z').to_a.shuffle[0..7]
=> ["r", "c", "u", "k", "v", "d", "h", "g"]
>> ('a'..'z').to_a.shuffle[0..7].join
=> "hkyufdes"
>> [0..16].map { |i| i**2 }
NoMethodError: undefined method `**' for 0..16:Range
  from (irb):132:in `block in irb_binding'
  from (irb):132:in `map'
  from (irb):132
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> [0..16].map { |i| i**2 }
NoMethodError: undefined method `**' for 0..16:Range
  from (irb):133:in `block in irb_binding'
  from (irb):133:in `map'
  from (irb):133
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> [0..16].to_a.map { |i| i**2 }
NoMethodError: undefined method `**' for 0..16:Range
  from (irb):134:in `block in irb_binding'
  from (irb):134:in `map'
  from (irb):134
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> (0..16).map { |i| i**2 }
=> [0, 1, 4, 9, 16, 25, 36, 49, 64, 81, 100, 121, 144, 169, 196, 225, 256]
>> def yeller(a)
>> a.map(&:upcase).join
>> end
=> :yeller
>> yeller([’o’, ’l’, ’d’])
NameError: undefined local variable or method `’o’' for main:Object
  from (irb):139
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> yeller(['o', 'l', 'd'])
=> "OLD"
>> def random_subdomain
>> ('a'..'z').shuffle[0..7].join
>> end
=> :random_subdomain
>> random_subdomain
NoMethodError: undefined method `shuffle' for "a".."z":Range
  from (irb):142:in `random_subdomain'
  from (irb):144
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> def random_subdomain
>> ('a'..'z').to_a.shuffle[0..7].join
>> end
=> :random_subdomain
>> random_subdomain
=> "qxhzmscr"
>> random_subdomain
=> "ahwcsqtl"
>> random_subdomain
=> "iagftmnw"
>> random_subdomain
=> "zyuokclt"
>> random_subdomain
=> "xptghemk"
>>
?> random_subdomain
=> "jxvwpugn"
>> def string_shuffle(s)
>> s.to_a.shuffle.join
>> end
=> :string_shuffle
>> string_shuffle("foobar")
NoMethodError: undefined method `to_a' for "foobar":String
Did you mean?  to_c
               to_r
               to_d
               to_f
               to_i
               to_s
  from (irb):156:in `string_shuffle'
  from (irb):158
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> def string_shuffle(s)
>> s.split('').shuffle.join
>> end
=> :string_shuffle
>> string_shuffle("foobar")
=> "aorbfo"
>> string_shuffle("foobar")
=> "orofab"
>> string_shuffle("foobar")
=> "raobof"
>> string_shuffle("foobar")
=> "foabro"
>> string_shuffle("foobar")
=> "bofaro"
>> string_shuffle("foobar")
=> "orbafo"
>> string_shuffle("foobar")
=> "ofabor"
>> string_shuffle("foobar")
=> "oaofbr"
>> string_shuffle("foobar")
=> "afrboo"
>> user={}
=> {}
>> user["first"]="Michael"
=> "Michael"
>> user["last"]="Hartl"
=> "Hartl"
>> user
=> {"first"=>"Michael", "last"=>"Hartl"}
>> user[123]=456
=> 456
>> user
=> {"first"=>"Michael", "last"=>"Hartl", 123=>456}
>> :foo_bbar
=> :foo_bbar
>> :foo-bar
NameError: undefined local variable or method `bar' for main:Object
  from (irb):178
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> user1={}
=> {}
>> user1[:name]="MH"
=> "MH"
>> user1[:password]="abc"
=> "abc"
>> user1
=> {:name=>"MH", :password=>"abc"}
>> user2={name:"MH",password:"abc"}
=> {:name=>"MH", :password=>"abc"}
>> h2={:name=>"MH", :password=>"abc"}
=> {:name=>"MH", :password=>"abc"}
>> h1==h2
NameError: undefined local variable or method `h1' for main:Object
  from (irb):185
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> user2==h2
=> true
>> user1=h2
=> {:name=>"MH", :password=>"abc"}
>> user1=^C
>> user1=>>
?>
?>
?>
?>
?> hash1={a:1,b:2}
=> {:a=>1, :b=>2}
>> hash2={c:3,d:hash1}
=> {:c=>3, :d=>{:a=>1, :b=>2}}
>> hash2.each { |k, v| puts "#{k.inspect} has value #{v.inspect}" }
:c has value 3
:d has value {:a=>1, :b=>2}
=> {:c=>3, :d=>{:a=>1, :b=>2}}
>> p
=> nil
>> p "a"
"a"
=> "a"
>> p :name
:name
=> :name
>> q
NameError: undefined local variable or method `q' for main:Object
  from (irb):199
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> def q(o)
>> puts o.inspect
>> return o
>> end
=> :q
>> q :name
:name
=> :name
>> q "abc"
"abc"
=> "abc"
>> q 123
123
=> 123
>> (1..5).to_a.inspect
=> "[1, 2, 3, 4, 5]"
>> (1..5).inspect
=> "1..5"
>> user2
=> {:name=>"MH", :password=>"abc"}
>> hash2
=> {:c=>3, :d=>{:a=>1, :b=>2}}
>> hash2[:d][:b}
SyntaxError: (irb):211: syntax error, unexpected tSTRING_DEND, expecting ']'
hash2[:d][:b}
             ^
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> hash2[:d][:b]
=> 2
>> ('a'..'z').to_a.shuffle[0..15]
=> ["j", "a", "y", "w", "q", "m", "c", "s", "b", "u", "k", "e", "h", "v", "g", "o"]
>> ('a'..'z').to_a.shuffle[0..15].join
=> "pvtrmiywdcbhnxfl"
>> h3 = h1.merge(h2)
NameError: undefined local variable or method `h1' for main:Object
  from (irb):215
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> hash3 = hash1.merge(hash2)
=> {:a=>1, :b=>2, :c=>3, :d=>{:a=>1, :b=>2}}
>> hash3
=> {:a=>1, :b=>2, :c=>3, :d=>{:a=>1, :b=>2}}
>>
Running via Spring preloader in process 17444
Loading development environment (Rails 5.0.1)
>> s="foobar"
=> "foobar"
>> s.class
=> String
>> s=String.new("foobar")
=> "foobar"
>> s.class
=> String
>> s == "foobar"
=> true
>> Array.new([1, 2, 3])
=> [1, 2, 3]
>> Hash.new
=> {}
>> Hash.new(3)
=> {}
>> h=Hash.new(3)
=> {}
>> h1={}
=> {}
>> h[:name]
=> 3
>> h1[:name]
=> nil
>> Range.new(1,10)
=> 1..10
>> (1..10)==Range.new(1,10)
=> true
>> s="abx"
=> "abx"
>> s.class
=> String
>> s.class.superclass
=> Object
>> s.class.superclass.superclass
=> BasicObject
>> s.class.superclass.superclass.superclass
=> nil
>> class Word
>> def palindrome>?(string)
>> string == string.reverse
>> end
SyntaxError: (irb):21: syntax error, unexpected '>', expecting ';' or '\n'
def palindrome>?(string)
               ^
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> def palindrome?(string)
>> string == string.reverse
>> end
=> :palindrome?
>> end
SyntaxError: (irb):27: syntax error, unexpected keyword_end
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> class Word
>> def palindrome?(string)
>> string == string.reverse
>> end
>> end
=> :palindrome?
>> w=Word.new
=> #<Word:0x007fa09b9a05b8>
>> w.palindrome?("foobar")
=> false
>> w.palindrome?("level")
=> true
>> class Word < String
>> def palindrome?
>> self==self.reverse
>> end
>> end
TypeError: superclass mismatch for class Word
  from (irb):36
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> class Word2 < String
>> def palindrome?
>> self==self.reverse
>> end
>> end
=> :palindrome?
>> s=Word.new("level")
ArgumentError: wrong number of arguments (given 1, expected 0)
  from (irb):46:in `initialize'
  from (irb):46:in `new'
  from (irb):46
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> s=Word1.new("level")
NameError: uninitialized constant Word1
  from (irb):47
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> s=Word2.new("level")
=> "level"
>> s.palindrome?
=> true
>> s=Word2.new("foobar")
=> "foobar"
>> s.length
=> 6
>> s.palindrome?
=> false
>> s.class
=> Word2
>> s.class.superclass
=> String
>> s.class.superclass.superclass
=> Object
>> s.class.superclass.superclass.superclass
=> BasicObject
>> class Word3
>> def palindrome?
>> self==reverse
>> end
>> end
=> :palindrome?
>> Word3.new("aba").palindrome?
ArgumentError: wrong number of arguments (given 1, expected 0)
  from (irb):62:in `initialize'
  from (irb):62:in `new'
  from (irb):62
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> class Word4 < String
>> def palindrome?
>> self==reverse
>> end
>> end
=> :palindrome?
>> Word4.new("aba").palindrome?
=> true
>>
➜  sample_app git:(master) rails console
Running via Spring preloader in process 17676
Loading development environment (Rails 5.0.1)
>> r=(1..5)
=> 1..5
>> r.class
=> Range
>> r.class.superclass
=> Object
>> "level".palindrome?
NoMethodError: undefined method `palindrome?' for "level":String
  from (irb):4
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `block in require'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:293:in `require'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `block in load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:259:in `load_dependency'
  from /usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/dependencies.rb:287:in `load'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/commands/rails.rb:6:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/command_wrapper.rb:38:in `call'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:191:in `block in serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `fork'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:161:in `serve'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:131:in `block in run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `loop'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application.rb:125:in `run'
  from /usr/local/lib/ruby/gems/2.4.0/gems/spring-1.7.2/lib/spring/application/boot.rb:19:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>> class String
>> def palindrome?
>> self==reverse
>> end
>> end
=> :palindrome?
>> "level".palindrome?
=> true
>> "".blank?
=> true
>> "abc".blank?
=> false
>> "    ".blank?
=> true
>> "\t".blank?
=> true
>> nil.blank?
=> true
>> false.blank?
=> true
>> true.blank?
=> false
>> class String
>> def shuffle
>> self.split('').shuffle.join
>> end
>> end
=> :shuffle
>> "abcdefgh".shuffle
=> "cgfaedbh"
>> "abcdefgh".shuffle
=> "bahfgedc"
>> controller=StaticPagesController.new
=> #<StaticPagesController:0x007fa0984f78e8 @_action_has_layout=true, @_routes=nil, @_request=nil, @_response=nil>
>> controller.class
=> StaticPagesController
>> controller.class.superclass
=> ApplicationController
>> controller.class.superclass.superclass
=> ActionController::Base
>> controller.class.superclass.superclass.superclass
=> ActionController::Metal
>> controller.class.superclass.superclass.superclass.superclass
=> AbstractController::Base
>> controller.class.superclass.superclass.superclass.superclass.superclass
=> Object
>> controller.home
=> nil
>> u1=User.new
NameError: uninitialized constant User
  from (irb):33
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console.rb:65:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/console_helper.rb:9:in `start'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:78:in `console'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands/commands_tasks.rb:49:in `run_command!'
  from /usr/local/lib/ruby/gems/2.4.0/gems/railties-5.0.1/lib/rails/commands.rb:18:in `<top (required)>'
  from /Users/licheng/GitHub/misc/rails/sample_app/bin/rails:9:in `<top (required)>'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from /usr/local/lib/ruby/site_ruby/2.4.0/rubygems/core_ext/kernel_require.rb:55:in `require'
  from -e:1:in `<main>'
>>
➜  sample_app git:(master) cd ..
➜  rails git:(master) ls
hello_app  sample_app toy_app
➜  rails git:(master) cd toy_app
➜  toy_app git:(master) rails console
/usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/xml_mini.rb:51: warning: constant ::Fixnum is deprecated
/usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/xml_mini.rb:52: warning: constant ::Bignum is deprecated
/usr/local/lib/ruby/gems/2.4.0/gems/activesupport-5.0.1/lib/active_support/core_ext/numeric/conversions.rb:138: warning: constant ::Fixnum is deprecated
Running via Spring preloader in process 17773
Loading development environment (Rails 5.0.1)
>> user1 = User.new
=> #<User id: nil, name: nil, email: nil, created_at: nil, updated_at: nil>
>> user1.class
=> User(id: integer, name: string, email: string, created_at: datetime, updated_at: datetime)
>> user1.class.superclass
=> ApplicationRecord(abstract)
>> user1.class.superclass.superclass
=> ActiveRecord::Base
>> user1.class.superclass.superclass.superclass
=> Object

class User
  attr_accessor :name, :email

  def initialize(attributes = {})
    @name = attributes[:name]
    @email = attributes[:email]
  end

  def formatted_email
    "#{@name} <#{@email}>"
  end
end
➜  toy_app git:(master) rails console
Running via Spring preloader in process 17958
Loading development environment (Rails 5.0.1)
>> class User
>>   attr_accessor :name, :email
>>
?>   def initialize(attributes = {})
>>     @name = attributes[:name]
>>     @email = attributes[:email]
>>   end
>>
?>   def formatted_email
>>     "#{@name} <#{@email}>"
>>   end
>> end
=> :formatted_email
>> user1 = User.new(name: "Lewis Cheng", email: "licheng@microsoft.com")
=> #<User:0x007f8fb40ba540 @name="Lewis Cheng", @email="licheng@microsoft.com">
>> user1
=> #<User:0x007f8fb40ba540 @name="Lewis Cheng", @email="licheng@microsoft.com">
>> user1.email
=> "licheng@microsoft.com"
>> user1.formatted_email
=> "Lewis Cheng <licheng@microsoft.com>"
>> user1.name="Bill Gates"
=> "Bill Gates"
>> user1.formatted_email
=> "Bill Gates <licheng@microsoft.com>"
>> class User
>> def alphabetical_name
>> @name.split(' ').reverse.join(', ')
>> end
>> end
=> :alphabetical_name
>> user1.alphabetical_name
=> "Gates, Bill"
>> exit
➜  toy_app git:(master)
