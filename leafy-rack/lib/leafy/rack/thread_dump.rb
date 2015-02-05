require 'leafy/rack'

java_import java.lang.management.ManagementFactory

module Leafy
 module Rack
   class ThreadDumpWriter

      def initialize
        begin
          # Some PaaS like Google App Engine blacklist java.lang.managament
          @threads = com.codahale.metrics.jvm.ThreadDump.new(ManagementFactory.getThreadMXBean());
        rescue LoadError
          # we won't be able to provide thread dump
        end
      end

      def to_text
        if @threads
          # TODO make this stream
          output = java.io.ByteArrayOutputStream.new
          @threads.dump(output)
          output.to_s
        end
      end
    end

    class ThreadDump

      WRITER = ThreadDumpWriter.new

      def self.response
        dump = WRITER.to_text
        [  
         200, 
         { 'Content-Type' => 'text/plain',
           'Cache-Control' => 'must-revalidate,no-cache,no-store' }, 
         [ dump ? dump : 'Sorry your runtime environment does not allow to dump threads.' ]
        ]
      end

      def initialize(app, path = '/threads')
        @app = app
        @path = path
      end

      def call(env)
        if env['PATH_INFO'] == @path
          ThreadDump.response
        else
          @app.call( env )
        end
      end
    end
  end
end
