require 'support/test_helper'

module RubySlippers::Engine
  context "Invalid Routes" do
    setup do
      @config = Config.new(:markdown => true, :author => AUTHOR, :url => URL)
      @ruby_slippers = Rack::MockRequest.new(App.new(@config))  
      
      if File.expand_path("../../", __FILE__) =~ /engine/
        Paths[:articles]  = "test/fixtures/articles"
        Paths[:templates] = "test/fixtures/templates"
        Paths[:pages]     = "test/fixtures/pages"
      end
    end
    
    context "GET to an unknown route with a custom error" do
      setup do
        @config[:error] = lambda {|code| "error: #{code}" }
        @ruby_slippers.get('/unknown')
      end

      should("returns a 404") { topic.status }.equals 404
      should("return the custom error") { topic.body }.equals "error: 404"
    end

    context "Request is invalid" do
      setup { @ruby_slippers.delete('/invalid') }
      should("returns a 400") { topic.status }.equals 400
    end
  end
end