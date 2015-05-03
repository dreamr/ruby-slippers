# Brought to you from the people behind www.rubycasts.io

Check out these awesome [ruby and rails screencasts](https://www.rubycasts.io)! There is 1 15 minute cast released every week as well as either a 2 Minute Ruby or a 2 Minute Rails screencast!

RubySlippers, the smartest blogging engine in all of Oz!
================
[website](http://ruby-slippers.heroku.com)

RubySlippers is a git powered blog engine that aims to be simply to modify and more importantly, simple and quick and free to get a blog going. I am currently using it to run several blogs in production, you can see one in action here:

[www.ninjaconfessions.com](www.ninjaconfessions.com) - My ruby blog

Introduction
------------

### To set up a new blog

    $ git clone git://github.com/dreamr/ruby-slippers.git myblog
    $ cd myblog
    $ gem install bundler
    $ bundle
    $ rake install
    $ -> Blog name: My new blog
    $ Installing your blog to my-new-blog
    $ Blog installed!
    
    
### To create an article

    $ rake new
    $ -> Title: My new blog post!
    $ Creating and opening my-new-blog-post (opens in your text editor!)
    $ rake publish (commits, pushes, publishes then opens in your browser!)

Deployment
==========

### On Heroku

RubySlippers comes with a basic rackup file. To start it up locally do:

    $ git remote add origin git@heroku:you-app-name
    $ git commit -m "my new awesome commit"
    $ git push

### On your own server

Once you have created the remote git repo, and pushed your changes to it, you can run RubySlippers with any Rack compliant web server, such as **thin**, **mongrel** or **unicorn**.

I use [shotgun](https://github.com/rtomayko/shotgun):

    $ shotgun
    
With thin, you would do something like:

    $ thin start -R config.ru

With unicorn, you can just do:

    $ unicorn


#### Configuration

You can configure ruby-slippers, by modifying the _config.ru_ file. For example, if you want to set the blog author to 'John Galt',
you could add `set :author, 'John Galt'` inside the `RubySlippers::Engine::App.new` block. Here are the defaults, to get you started:

    set :author,      ENV['USER']                               # blog author
    set :title,       Dir.pwd.split('/').last                   # site title
    set :url,         'http://example.com'                      # site root URL
    set :prefix,      ''                                        # common path prefix for all pages
    set :root,        "index"                                   # page to load on /
    set :date,        lambda {|now| now.strftime("%d/%m/%Y") }  # date format for articles
    set :markdown,    :smart                                    # use markdown + smart-mode
    set :disqus,      false                                     # disqus id, or false
    set :summary,     :max => 150, :delim => /~\n/              # length of article summary and delimiter
    set :ext,         'txt'                                     # file extension for articles
    set :cache,       28800                                     # cache site for 8 hours

    set :to_html   do |path, page, ctx|                         # returns an html, from a path & context
      ERB.new(File.read("#{path}/#{page}.html.erb")).result(ctx)
    end

    set :error     do |code|                                    # The HTML for your error page
      "<font style='font-size:300%'>A large house has landed on you. You cannot continue because you are dead. <a href='/'>try again</a> (#{code})</font>"
    end

Philosophy
----------

RubySlippers is based on [Toto](http://github.com/cloudhead/toto) and aims to achieve their goals as well as our own. Hosting a ruby based free blog shouldn't be hard. We want to take that a step further and say it should be easy. Easy as pie. Easy as my best friend's Mom. Easy as a 1 click installer.

Oh yeah, MRI, bytecode whatever. If it is Ruby, it should run.

### How it works

- Article management is done with a text editor and git
  * stored as _.txt_ files, with embeded metadata (in yaml format).
  * processed through a markdown converter (rdiscount) by default.
  * can have tags
  * can have images
  * can be browsed by date, or tags
  * comments are handled by [disqus](http://disqus.com)
- built for easy use with _ERB_.
- built right on top of _Rack_.
- built to take advantage of _HTTP caching_.
- built with _heroku_ in mind.


RubySlippers comes with a basic default theme for you to mangle. I hope to release more themes shortly and will accept your submitted themes.

### Thanks

* To heroku for making this easy as pie.
* To the developers of [Toto](http://github.com/cloudhead/toto), for making such an awesome minimal blog engine in Ruby.

Copyright (c) 2011 dreamr. See LICENSE for details.
