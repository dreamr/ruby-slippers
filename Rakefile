require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'ruby_slippers'
require "./lib/ruby_slippers/client/tasks"

task :default => :new

Rake::TestTask.new("test") do |test|
  test.libs << 'lib' << 'test'
  test.pattern = "test/client_tasks/*_test.rb"
  test.verbose = true
end

desc "Install my blog."
task :install do
  RubySlippers::Client::Tasks.install_blog!
end

desc "Create a new article."
task :new do
  RubySlippers::Client::Tasks.create_article!
end

desc "Publish my blog."
task :publish do
  RubySlippers::Client::Tasks.publish_blog!
end

