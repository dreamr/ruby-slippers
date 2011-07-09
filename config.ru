
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

require File.expand_path("../config", __FILE__)
run $app