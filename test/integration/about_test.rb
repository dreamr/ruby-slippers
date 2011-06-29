require 'support/test_helper'
require 'date'

module RubySlippers::Engine
  context "Routes" do
    setup do
      @config = Config.new(:markdown => true, :author => AUTHOR, :url => URL)
      @ruby_slippers = Rack::MockRequest.new(App.new(@config))  
      
      if File.expand_path("../../", __FILE__) =~ /engine/
        Paths[:articles]  = "test/fixtures/articles"
        Paths[:templates] = "test/fixtures/templates"
        Paths[:pages]     = "test/fixtures/pages"
      end
    end

    context "GET /about" do
      setup { @ruby_slippers.get('/about') }
      asserts("return a 200") { topic.status }.equals 200
      asserts("body is not empty")  { not topic.body.empty? }
    end
  end
end
