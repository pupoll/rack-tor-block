require 'rack'
require 'rack/ip'

module Rack
  class TorBlock
    
    DEFAULT_REDIRECT = 'http://localhost:3000/no_js'
    def initialize(app)
      @app = app
    end

    def call(env)
      req = Rack::Request.new(env)
      return [302, {'Content-Type' => 'text/html', 'Location' => DEFAULT_REDIRECT}, [] ] if (Rack::IP.new(env['action_dispatch.remote_ip'] || req.ip).is_tor?) && req.url != DEFAULT_REDIRECT
        
      #Normal processing
      @app.call(env)
    end
  end
end