require 'support/test_helper'

module RubySlippers::Engine
  context "Tagged Routes" do
    setup do
      @config = Config.new(:markdown => true, :author => AUTHOR, :url => URL)
      @ruby_slippers = Rack::MockRequest.new(App.new(@config))
      
      if File.expand_path("../../", __FILE__) =~ /engine/
        Paths[:articles]  = "test/fixtures/articles"
        Paths[:templates] = "test/fixtures/templates"
        Paths[:pages]     = "test/fixtures/pages"
      end
    end
    
    context "GET the tagged page" do 
      setup { @ruby_slippers.get('/tagged/oz') }
      asserts("return a 200") { topic.status }.equals 200 
      asserts("body is not empty") {not topic.body.empty? }
      should("include only the entries for that tag") { topic.body }.includes_elements("li.article", 2)
      should("have access to @tag") { topic.body }.includes_html("h1" => /oz/)
    end
  end
end