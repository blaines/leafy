require 'leafy/rack/metrics'
require 'leafy/rack/health'
require 'leafy/rack/ping'
require 'leafy/rack/thread_dump'

module Leafy
  module Rack
    class Admin
      
      def self.response( path )
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
      <li><a href='#{path}/metrics'>metrics</a> (<a href='#{path}/metrics?pretty'>pretty</a>)</li>
      <li><a href='#{path}/health'>health</a> (<a href='#{path}/health?pretty'>pretty</a>)</li>
      <li><a href='#{path}/ping'>ping</a></li>
      <li><a href='#{path}/threads'>thread-dump</a></li>
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
        when '/'
          Admin.response( @path )
        when ''
          Admin.response( @path )
        else # let the app deal with "not found"
          @app.call( env )
        end
      end
    end
  end
end
