require 'rake/testtask'

desc "run tests"
task :test do
  $LOAD_PATH.unshift('test')
  Dir.glob('./test/**/*_test.rb').each { |file| require file }
end

desc "console"
task :console do
  exec("irb -Ilib -rmatasano/utils")
end
