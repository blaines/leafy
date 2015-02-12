module Leafy
  module Metrics
    class Graphite

      attr_reader :sender

      def initialize( sender )
        unless sender.java_kind_of? Java::ComCodahaleMetricsGraphite::GraphiteSender
          raise "not instance of 'Java::ComCodahaleMetricsGraphite::Graphite'"
        end
        @sender = sender
      end
  
      def self.new_tcp( hostname, port )
        new com.codahale.metrics.graphite.Graphite.new( hostname, port )
      end

      def self.new_udp( hostname, port )
        new com.codahale.metrics.graphite.GraphiteUDP.new( hostname, port )
      end

      def self.new_pickled( hostname, port, batchsize )
        new com.codahale.metrics.graphite.PickledGraphite.new( hostname, port, batchsize )
      end
    end
  end
end

