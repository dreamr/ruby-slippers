require 'support/test_helper'

module RubySlippers::Engine
  context "Atom Feed" do
    setup do
      @config = Config.new(:markdown => true, :author => AUTHOR, :url => URL)
      @ruby_slippers = Rack::MockRequest.new(App.new(@config))

      if File.expand_path("../../", __FILE__) =~ /engine/
        Paths[:articles]  = "test/fixtures/articles"
        Paths[:templates] = "test/fixtures/templates"
        Paths[:pages]     = "test/fixtures/pages"
      end
    end

    context "GET /index.xml (atom feed)" do
      setup { @ruby_slippers.get('/index.xml') }
      asserts("content type is set properly") { topic.content_type }.equals "application/xml"
      asserts("body should be valid xml") { topic.body }.includes_html("feed > entry" => /.+/)
      asserts("summary shouldn't be empty")   { topic.body }.includes_html("summary" => /.{10,}/)
    end

  end
end
