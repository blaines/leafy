require 'leafy/json/health_writer'

module Rack
  module Leafy
    class Health

      WRITER = ::Leafy::Json::HealthWriter.new

      def self.response( health, env )
        data = health.run_health_checks
        is_healthy = data.values.all? { |r| r.healthy? }
        [
         is_healthy ? 200 : 500, 
         { 'Content-Type' => 'application/json',
           'Cache-Control' => 'must-revalidate,no-cache,no-store' }, 
         [ WRITER.to_json( data, env[ 'QUERY_STRING' ] == 'pretty' ) ]
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
