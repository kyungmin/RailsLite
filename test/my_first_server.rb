require 'active_support/core_ext'
require 'webrick'

server = WEBrick::HTTPServer.new :Port => 8080
trap('INT') { server.shutdown }

server.mount_proc '/' do |req, res|
  res.body = "hello"
end

server.start