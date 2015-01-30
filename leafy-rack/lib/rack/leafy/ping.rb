module Rack
  module Leafy
    class Ping
      
      def self.response
        [ 
         200, 
         { 'Content-Type' => 'text/plain',
           'Cache-Control' => 'must-revalidate,no-cache,no-store' }, 
         [ 'pong' ]
        ]
      end

      def initialize(app, path = '/ping')
        @app = app
        @path = path
      end

      def call(env)
        if env['PATH_INFO'] == @path
          Ping.response
        else
          @app.call( env )
        end
      end
    end
  end
end
