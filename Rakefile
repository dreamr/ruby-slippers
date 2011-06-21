require 'ruby_slippers'
@config = RubySlippers::Engine::Config::Defaults

task :default => :new

desc "Install my blog."
task :install do
  blog = ask('Blog name: ')
  slug = blog.empty?? nil : blog.strip.slugize
  puts "Installing your blog to #{slug}"
  `heroku create #{slug}`
  puts 'Blog installed!'
  `heroku open`
end

desc "Create a new article."
task :new do
  title = ask('Title: ')
  slug = title.empty?? nil : title.strip.slugize

  article = {'title' => title, 'date' => Time.now.strftime("%d/%m/%Y")}.to_yaml
  article << "\n"
  article << "article text here\n\n"

  path = "#{RubySlippers::Engine::Paths[:articles]}/#{Time.now.strftime("%Y-%m-%d")}#{'-' + slug if slug}.#{@config[:ext]}"

  unless File.exist? path
    puts "Creating and opening #{slug}"
    File.open(path, "w") do |file|
      file.write article
    end
    `open #{path}`
  else
    puts "I can't create the article, #{path} already exists."
  end
end

desc "Publish my blog."
task :publish do
  puts "publishing your article(s) to heroku..."
  `git add .`
  `git commit -a -m 'MODIFIED ARTICLE(S)'`
  `git push heroku master`
  `heroku open`
end

def ask message
  print message
  STDIN.gets.chomp
end

