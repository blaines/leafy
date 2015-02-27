require 'leafy/health'
require 'leafy/health/health_check'
module Leafy
  module Health
    class Registry

      # state ofthe registry
      attr_reader :health

      def initialize
        @health = com.codahale.metrics.health.HealthCheckRegistry.new
      end

      # register a HealthCheck under a given name
      # 
      # @param [String] name
      # @param [String] instead of block any check object which responds to 'call'
      # @yieldparam [HealthCheckRegistry::HealthCheck] which has convienient methods to create healthy and unhealthy results with message
      # @yieldreturn [String] if the healthcheck fails return the message
      # @yieldreturn [NilClass] if the healthcheck succeeds
      # @yieldreturn [com.codahale.metrics.health.HealthCheck::Result] if the check produces its own result object
      def register(name, check = nil, &block )
        if check and not block_given? and check.is_a? HealthCheck
          @health.register( name, check )
        elsif check.nil? and block_given?
          @health.register( name, HealthCheck.new( &block ) )
        else
          raise 'needs either a block and object with call method'
        end
      end
 
      # unregister a HealthCheck for a given name
      # 
      # @param [String] name
      def unregister(name)
        @health.unregister(name)
      end

      # the names of all registered HealthCheck
      # 
      # @return [Array<String>] names of HealthCheck in order of their registration
      def names
        @health.names.to_a
      end

      # # run a healthcheck for a given name
      # # 
      # # @param [String] name
      # # @return [Java::ComCodahaleMetricsHealth::HealthCheck::Result] result of the health-check
      # def run_health_check(name) 
      #   @health.runHealthCheck(name)
      # end
    end
  end
end
