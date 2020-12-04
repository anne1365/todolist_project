require 'rake/testtask'
require 'bundler/gem_tasks'
require 'find'

desc 'Say hello'
task :hello do
    puts "Hello there. This is the 'hello' task."
end

desc 'Run tests'
task :default => :test

Rake::TestTask.new(:test) do |t|
    t.libs << "test"   # tests in test dir
    t.libs << "lib"    # source code in lib dir
    t.test_files = FileList['test/**/*_test.rb'] 
    # ^ test files end in '_test.rb'
end

desc 'List all files'
task :inventory do
   Find.find('.') do |name|
    next if name.include?('/.')
    puts name if File.file?(name)
   end
end