require 'leafy/metrics/registry'

java_import java.util.concurrent.TimeUnit;

module Leafy
  module Metrics
    class Reporter
      # copy the TimeUnit constants
      TimeUnit.constants.each do |c|
        const_set( c, TimeUnit.const_get( c ) )
      end

      def initialize( reporter )
        @reporter = reporter
      end

      def start( period, time_unit )
        @reporter.start( period, time_unit )
      end

      def stop
        @reporter.stop
      end

      def report
        @reporter.report
      end

      class Builder
        def initialize( reporter_class, metrics )
          @builder = reporter_class.for_registry( metrics.metrics )
          self
        end
        
        def convert_rates_to( time_unit )
          @builder.convert_rates_to( time_unit )
          self
        end
        
        def convert_durations_to( time_unit )
          @builder.convert_durations_to( time_unit )
          self
        end
      end
    end
  end
end

