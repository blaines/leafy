module Leafy
  module Instrumented
    class BasicInstrumented

      NAME_PREFIX = "responseCodes"

      def initialize( registry, name, meter_names_by_status_code = {} )
        @meters_by_status_code = java.util.concurrent.ConcurrentHashMap.new
        meter_names_by_status_code.each do |k,v|
          @meters_by_status_code[ k ] = registry.register_meter( "#{name}.#{v}" )
        end
        @other = registry.register_meter( "#{name}.#{NAME_PREFIX}.other" )
        @active = registry.register_counter( "#{name}.active_requests" )
        @timer = registry.register_timer( "#{name}.requests" )
      end

      def call( &block )
        raise "block needed" unless block_given?
        @active.inc

        @timer.time do

          result = block.call
          mark_meter_for_status_code result[0]
          result

        end
      ensure
        @active.dec
      end

      def mark_meter_for_status_code( status )
        metric = @meters_by_status_code[ status ] || @other
        metric.mark
      end
    end
  end
end
