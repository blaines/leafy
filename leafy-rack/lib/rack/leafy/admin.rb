require 'rack/leafy/metrics'
require 'rack/leafy/health'
require 'rack/leafy/ping'
require 'rack/leafy/thread_dump'

module Rack
  module Leafy
    class Admin
      
      def self.response
        [  
         200, 
         { 'Content-Type' => 'text/html' }, 
         [ <<EOF
<DOCTYPE html>
<html>
  <head>
    <title>metrics</title>
  </head>
  <body>
    <h1>menu</h1>
    <ul>
      <li><a href='metrics'>metrics</a></li>
      <li><a href='health'>health</a></li>
      <li><a href='ping'>ping</a></li>
      <li><a href='threads'>thread-dump</a></li>
    </ul>
  </body>
</html>  
EOF
         ]
        ]
      end

      def initialize(app, metrics_registry, health_registry, path = '/admin')
        @app = app
        @path = path
        @metrics = metrics_registry
        @health = health_registry
      end

      def call(env)
        if ( path = env['PATH_INFO'] ).start_with? @path
          dispatch( path.sub( /#{@path}/, ''), env )
        else
          @app.call( env )
        end
      end

      private

      def dispatch( path, env )
        case path
        when '/metrics'
          Metrics.response( @metrics.metrics, env )
        when '/health'
          Health.response( @health.health, env )
        when '/ping'
          Ping.response
        when '/threads'
          ThreadDump.response
        else
          Admin.response
        end
      end
    end
  end
end
