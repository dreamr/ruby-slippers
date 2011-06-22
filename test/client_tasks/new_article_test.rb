require 'support/test_helper'

module RubySlippers::Client
  context Tasks do
    setup do
      RubySlippers::Engine::Paths[:articles] = File.expand_path("../../fixtures/temp", __FILE__)
      `rm -rf #{RubySlippers::Engine::Paths[:articles]}/*.txt`
      Tasks
    end
    
    context "create_article!" do      
      should("create an article") do
        mock(topic).ask("Title: ") { "My test article" }
        topic.create_article!
      end.equals true
      
      should("wont create a duplicate article") do
        mock(topic).ask("Title: ") { "My test article" }
        topic.create_article!
      end.equals false
      
    end
  
    context "install_blog!" do
      setup do
        `heroku destroy slippers-test-blog`
      end
      
      should("installs blog on heroku") do
        mock(topic).ask("Blog name: ") { "slippers test blog" }
        topic.install_blog!
      end.equals true
      
    end
  end
  
end
