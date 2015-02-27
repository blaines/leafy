require 'leafy/rack'
require 'leafy/json/health_writer'
require 'json' unless defined? :JSON

module Leafy
  module Rack
    class Health

      def self.response( health, env )
        data = health.run_health_checks
        is_healthy = data.values.all? { |r| r.healthy? }
        json = env[ 'QUERY_STRING' ] == 'pretty' ? JSON.pretty_generate( data.to_hash ) : data.to_hash.to_json
        [
         is_healthy ? 200 : 503, 
         { 'Content-Type' => 'application/json',
           'Cache-Control' => 'must-revalidate,no-cache,no-store' }, 
         [ json ]
        ]
      end

      def initialize(app, registry, path = '/health')
        @app = app
        @path = path
        @registry = registry
      end
      
      def call(env)
        if env['PATH_INFO'] == @path
          Health.response( @registry.health, env )
        else
          @app.call( env )
        end
      end
    end
  end
end
