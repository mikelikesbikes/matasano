require 'rake/testtask'

desc "run tests"
task :test do
  $LOAD_PATH.unshift('test')
  Dir.glob('./test/**/*_test.rb').each { |file| require file }
end
