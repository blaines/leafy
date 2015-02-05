require 'leafy/health'
require 'leafy/json/json_writer'

java_import com.codahale.metrics.json.HealthCheckModule

module Leafy
  module Json
    class HealthWriter < JsonWriter

      def initialize
        super( HealthCheckModule.new )
      end
    end
  end
end
