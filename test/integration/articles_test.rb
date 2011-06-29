require 'support/test_helper'

module RubySlippers::Engine
  context "Article Routes" do
    setup do
      @config = Config.new(:markdown => true, :author => AUTHOR, :url => URL)
      @ruby_slippers = Rack::MockRequest.new(App.new(@config))
      
      if File.expand_path("../../", __FILE__) =~ /engine/
        Paths[:articles]  = "test/fixtures/articles"
        Paths[:templates] = "test/fixtures/templates"
        Paths[:pages]     = "test/fixtures/pages"
      end
    end
    
    context "GET /" do
      setup { @ruby_slippers.get('/') }

      asserts("return a 200") { topic.status }.equals 200
      asserts("body is not empty")  { not topic.body.empty? }
      asserts("content type is set properly") { topic.content_type }.equals "text/html"
      should("include 3 articles"){ topic.body }.includes_elements("article", 3)

      context "with no articles" do
        setup { Rack::MockRequest.new(App.new(@config.merge(:ext => 'oxo'))).get('/') }

        asserts("body is not empty") { not topic.body.empty? }
        asserts("return a 200")    { topic.status }.equals 200
      end

      context "with a user-defined to_html" do
        setup do
          @config[:to_html] = lambda do |path, page, binding|
            ERB.new(File.read("#{path}/#{page}.html.erb")).result(binding)
          end
          @ruby_slippers.get('/')
        end

        asserts("return a 200") { topic.status }.equals 200
        asserts("body is not empty")  { not topic.body.empty? }
        asserts("content type is set properly") { topic.content_type }.equals "text/html"
        should("include 3 articles"){ topic.body }.includes_elements("article", 3)
        asserts("Etag header present") { topic.headers.include? "ETag" }
        asserts("Etag header has a value") { not topic.headers["ETag"].empty? }
      end
    end

    context "GET a single article" do
      setup { @ruby_slippers.get("/2010/05/17/the-wonderful-wizard-of-oz") }
      asserts("return a 200") { topic.status }.equals 200
      asserts("content type is set properly") { topic.content_type }.equals "text/html"
      should("contain the article") { topic.body }.includes_html("p" => /Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum./)
    end

    context "GET to the archive" do
      context "through a year" do
        setup { @ruby_slippers.get('/2010') }
        asserts("return a 200") { topic.status }.equals 200
        should("include the entries for that year") { topic.body }.includes_elements("div.archived_article", 3)
      end

      context "through a year & month" do
        setup { @ruby_slippers.get('/2010/05') }
        asserts("return a 200")  { topic.status }.equals 200
        should("include the entries for that month") { topic.body }.includes_elements("div.archived_article", 3)
        should("include the year & month") { topic.body }.includes_html("h1" => /2010\/05/)
      end

      context "through /archives" do
        setup { @ruby_slippers.get('/archives') }
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
