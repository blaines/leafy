require 'leafy/metrics/reporter'
require 'leafy/metrics/graphite/graphite'

java_import com.codahale.metrics.graphite.GraphiteReporter

module Leafy
  module Metrics
    class GraphiteReporter < Reporter

      class Builder < Reporter::Builder
        def initialize( metrics )
          super( ::GraphiteReporter, metrics )
        end
        
        def prefixed_with( prefix )
          @builder.prefixed_with( prefix )
          self
        end

        def build( graphite )
          Reporter.new( @builder.build( graphite.sender ) )
        end
      end

      def self.for_registry( metrics )
        Builder.new( metrics )
      end
    end
  end
end

