require 'leafy/metrics/reporter'

java_import com.codahale.metrics.ConsoleReporter

module Leafy
  module Metrics
    class ConsoleReporter < Reporter

      class Builder < Reporter::Builder
        def initialize( metrics )
          super( ::ConsoleReporter, metrics )
        end
        
        def output_to( io )
          # IO objects in jruby do have a to_outputstream method
          @io = java.io.PrintStream.new( io.to_outputstream )
          @builder.output_to( @io )
          self
        end
        
        def build
          Reporter.new( @builder.build )
        end
      end

      def self.for_registry( metrics )
        Builder.new( metrics )
      end
    end
  end
end

