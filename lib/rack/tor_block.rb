require 'rack'
require 'rack/ip'

module Rack
  class TorBlock
    
    ERROR_PAGE = '/blocked_proxy'
    def initialize(app)
      @app = app
    end

    def call(env)
      req = Rack::Request.new(env)
      return [302, {'Content-Type' => 'text/html', 'Location' => "#{req.scheme}://#{req.host_with_port}#{ERROR_PAGE}"}, [] ] if (Rack::IP.new(env['action_dispatch.remote_ip'] || req.ip).is_tor?) && !error_page?(req) && !asset?(req)
        
      #Normal processing
      @app.call(env)
    end
    
    def error_page?(req)
      req.url =~ /#{ERROR_PAGE}$/
    end
    
    def asset?(req)
      req.url =~ /\/assets\//
    end
  end
end