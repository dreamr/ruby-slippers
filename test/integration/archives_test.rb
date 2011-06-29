require 'support/test_helper'

module RubySlippers::Engine
  context "Archive Routes" do
    setup do
      @config = Config.new(:markdown => true, :author => AUTHOR, :url => URL)
      @ruby_slippers = Rack::MockRequest.new(App.new(@config))
      
      if File.expand_path("../../", __FILE__) =~ /engine/
        Paths[:articles]  = "test/fixtures/articles"
        Paths[:templates] = "test/fixtures/templates"
        Paths[:pages]     = "test/fixtures/pages"
      end
    end
    context "GET to the archive" do
      context "through a year" do
        setup { @ruby_slippers.get('/2011') }
        asserts("return a 200") { topic.status }.equals 200
        should("include the entries for that year") { topic.body }.includes_elements("div.archived_article", 1)
      end

      context "through a year & month" do
        setup { @ruby_slippers.get('/2011/05') }
        asserts("return a 200")  { topic.status }.equals 200
        should("include the entries for that month") { topic.body }.includes_elements("div.archived_article", 1)
        should("include the year & month") { topic.body }.includes_html("h1" => /2011\/05/)
      end

      context "through /archives" do
        setup { @ruby_slippers.get('/archives') }
      end
    end
  end
end
