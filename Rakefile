require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'ruby_slippers'
require 'lib/ruby_slippers/client/tasks'

task :default => :new

Rake::TestTask.new("test") do |test|
  test.libs << 'lib' << 'test'
  test.pattern = "test/client_tasks/*_test.rb"
  test.verbose = true
end

desc "Install my blog."
task :install do
  tasks = RubySlippers::Client::Tasks.new
  tasks.install_blog!
end

desc "Create a new article."
task :new do
  tasks = RubySlippers::Client::Tasks.new
  tasks.create_article!
end

desc "Publish my blog."
task :publish do
  tasks = RubySlippers::Client::Tasks.new
  tasks.publish_blog!
end

