require 'rake'
require 'date'

require 'heroku'

module RubySlippers
  module Client
    class Tasks
      include Rake::DSL
      
      @@config = RubySlippers::Engine::Config::Defaults
      
      def create_article!
        title = ask('Title: ')
        slug = title.empty?? nil : title.strip.slugize

        article = {
          'title' => title, 
          'date' => Time.now.strftime("%d/%m/%Y")
        }.to_yaml
        article << "\narticle text here\n\n"

        path = "#{RubySlippers::Engine::Paths[:articles]}/#{Time.now.strftime("%Y-%m-%d")}#{'-' + slug if slug}.#{@@config[:ext]}"

        unless File.exist? path
          puts "Creating and opening #{slug}"
          File.open(path, "w") do |file|
            file.write article
          end
          `open #{path}`
          true
        else
          puts "I can't create the article, #{path} already exists."
          false
        end
        
      end

      def install_blog!
        blog = ask('Blog name: ')
        slug = blog.empty?? nil : blog.strip.slugize
        puts "Installing your blog to #{slug}"
        `heroku create #{slug}`
        puts 'Blog installed!'
        `heroku open`
        true
      end
      
      def publish_blog!
        puts "publishing your article(s) to heroku..."
        `git add .`
        `git commit -a -m 'MODIFIED ARTICLE(S)'`
        `git push heroku master -f`
        `heroku open`
      end
      
    private
    
      def ask message
        print message
        STDIN.gets.chomp
      end

      
    end
  end
end
