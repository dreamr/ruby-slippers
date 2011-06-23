
begin
  # try to run as library (development)
  require './slippers_lib/ruby_slippers'
rescue LoadError
  # run as gem (lib not installed)
  require 'ruby_slippers'
end

# Rack config
use Rack::CommonLogger
use Rack::Static, 
  :urls => ['/css', '/js', '/img', '/favicon.ico'], :root => 'public'

#
# Create and configure a ruby-slippers instance
#
app = RubySlippers::Engine::App.new do
  # log_file = File.expand_path("../log/slippers.log", __FILE__)
  # log = File.new(log_file, "a+")
  # $stdout.reopen(log)
  # $stderr.reopen(log)
  
  #
  # Add your settings here
  # set [:setting], [value]
  # 
  set :author,      "Dreamr"                              # blog author
  set :title,       "RubySlippers, the smartest blog engine in all of Oz!"  # site title
  # set :root,      "index"                                   # page to load on /
  set :date,        lambda {|now| now.strftime("%Y/%m/%d") }    # date format for articles
  # set :markdown,  :smart                                    # use markdown + smart-mode
  # set :disqus,    false                                     # disqus id, or false
  set :summary,     :max => 300, :delim => /~/                # length of article summary and delimiter
  # set :ext,       'txt'                                     # file extension for articles
  # set :cache,      28800                                    # cache duration, in seconds
  set :tag_separator, ', '                                    # tag separator for articles
  set :date, lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }
  # set this to your local port. I use shotgun, so 9393.
  set :url, "http://localhost:9393" if ENV['RACK_ENV'] == 'development'

  # to use haml, add the gem to your Gemfile and bundle, then uncomment this
  # and redo your templates using haml
  # set :to_html, lambda { |path, page, binding| 
  #   Haml::Engine.new(File.read("#{path}/#{page}.haml"),
  #   :attr_wrapper => '"',
  #   :filename => path ).render(binding)
  # }
end

run app


