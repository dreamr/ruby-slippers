require 'rake'
require 'date'

require 'heroku'

begin
  require './slippers_lib/ext/ext'
rescue LoadError
  require 'ext/ext'
end

module RubySlippers
  module Client
    class Tasks
      include Rake::DSL
      
      ROOT = File.expand_path("../../../../", __FILE__)
      THUMBS = File.expand_path("../../../../public/img/archives/", __FILE__)
      
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
      
      def create_missing_thumbs!
        @@config[:url] = "http://localhost:9393"
        for article in RubySlippers::Engine::Site.articles(@@config[:ext])
          article = RubySlippers::Engine::Article.new article, @@config
          next if thumb_exists?(article.slug)
          start_web
          make_thumb article.url, THUMBS, article.slug
          clean_pid
        end
      end
      
    private
    
      def start_web
        cmd="cd #{ROOT} && rackup -p 9393 --pid ./rack.pid &"
        puts "starting web server"
        system cmd
      end
    
      def clean_pid
        puts "stopping web server"
        pid = File.read(ROOT+'/rack.pid')
        system "kill -9 #{pid}"
      end
    
      def thumb_exists?(path)
        File.exists? THUMBS+'/'+path+'-full.png'
      end
      
      def make_thumb(browse_to, save_to, image_name)
        cmd="cd #{ROOT} && python ./bin/webkit2png.py -F #{browse_to} -o #{save_to}/#{image_name}"
        system cmd
      end
    
      def ask message
        print message
        STDIN.gets.chomp
      end

      
    end
  end
end
