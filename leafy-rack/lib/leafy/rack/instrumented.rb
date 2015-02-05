require 'leafy/rack'
require 'leafy/instrumented/instrumented'

module Leafy
  module Rack
    class Instrumented
      
      def initialize( app, instrumented )
        @app = app
        @instrumented = instrumented
      end
      
      def call( env )
        @instrumented.call do
          @app.call env
        end
      end      
    end
  end
end
