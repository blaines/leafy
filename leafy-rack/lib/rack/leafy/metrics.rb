require 'leafy/json/metrics_writer'
module Rack
  module Leafy

    class Metrics

      WRITER = ::Leafy::Json::MetricsWriter.new

      def self.response( metrics, env )
        [ 
         200, 
         { 'Content-Type' => 'application/json',
           'Cache-Control' => 'must-revalidate,no-cache,no-store' }, 
         [ WRITER.to_json( metrics, env[ 'QUERY_STRING' ] == 'pretty' ) ]
        ]
      end

      def initialize(app, registry, path = '/metrics')
        @app = app
        @path = path
        @registry = registry
      end
      
      def call(env)
        if env['PATH_INFO'] == @path
          Metrics.response( @registry.metrics, env )
        else
          @app.call( env )
        end
      end
    end
  end
end
