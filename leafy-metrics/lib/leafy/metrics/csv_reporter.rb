require 'leafy/metrics/reporter'

java_import com.codahale.metrics.CsvReporter

module Leafy
  module Metrics
    class CSVReporter < Reporter

      class Builder < Reporter::Builder
        def initialize( metrics )
          super( ::CsvReporter, metrics )
        end
        
        def build( directory )
          directory = java.io.File.new( directory )
          Reporter.new( @builder.build( directory ) )
        end
      end

      def self.for_registry( metrics )
        Builder.new( metrics )
      end
    end
  end
end

