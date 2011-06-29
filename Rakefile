require 'rubygems'
require 'rake'
require 'rake/testtask'
require 'ruby_slippers'
require './lib/ruby_slippers/client/tasks'

TASKS = RubySlippers::Client::Tasks.new

task :default => :new

namespace :test do
  TEST_TYPES = %w(integration)
  TEST_TYPES.each do |type|
    Rake::TestTask.new(type) do |test|
      test.libs << 'lib' << 'test'
      test.pattern = "test/#{type}/*_test.rb"
      test.verbose = true
    end
  end
  
  Rake::TestTask.new(:all) do |test|
    test.libs << 'lib' << 'test'
    test.pattern = 'test/integration/*_test.rb'
    test.verbose = true
  end
end
task :test => 'test:all'

desc "Install my blog."
task :install do
  TASKS.install_blog!
end

desc "Create a new article."
task :new do
  TASKS.create_article!
end

desc "Publish my blog."
task :publish => :create_thumbs do
  TASKS.publish_blog!
end

desc "Create missing article thumbs"
task :create_thumbs do
  TASKS.create_missing_thumbs!
end

