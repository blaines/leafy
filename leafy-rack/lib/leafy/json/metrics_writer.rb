require 'leafy/metrics'
require 'leafy/json/json_writer'

java_import com.codahale.metrics.MetricFilter
java_import com.codahale.metrics.json.MetricsModule

java_import java.util.concurrent.TimeUnit

module Leafy
  module Json
    class MetricsWriter < JsonWriter

      def initialize
        super( # make this configurable
              MetricsModule.new(TimeUnit::SECONDS,
                                TimeUnit::SECONDS,
                                true,
                                MetricFilter::ALL) )
      end
    end
  end
end
