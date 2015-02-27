require_relative 'setup'
require 'leafy/metrics/graphite/graphite_reporter'

describe Leafy::Metrics::GraphiteReporter do

  subject { Leafy::Metrics::GraphiteReporter }

  let( :metrics ) { Leafy::Metrics::Registry.new }
  let( :requests ) { metrics.register_meter( "requests" ) }
  let( :logfile ) { LOG_FILE }

  graphites = [ Leafy::Metrics::Graphite.new_tcp( 'localhost', 12345 ),
                Leafy::Metrics::Graphite.new_pickled( 'localhost', 12345, 1 ) ]
  graphites.each_with_index do |graphite, index|
    describe graphite.sender.class do
      it 'run reporter with defaults' do
        log = File.read( logfile )
        begin
          reporter = subject.for_registry( metrics ).build( graphite )
          requests.mark
          reporter.start( 10, Leafy::Metrics::Reporter::MILLISECONDS )
          sleep 0.01
          reporter.stop
          result = File.read( logfile )[ (log.size)..-1 ]
          expect( result ).to match /metrics-graphite-reporter-.-thread-1] WARN com.codahale.metrics.graphite.GraphiteReporter/
        ensure
          reporter.stop if reporter
        end
      end

      it 'run reporter' do
        log = File.read( logfile )
        begin
          reporter = subject.for_registry( metrics )
            .convert_rates_to( Leafy::Metrics::Reporter::MILLISECONDS )
            .convert_durations_to( Leafy::Metrics::Reporter::MILLISECONDS )
            .prefixed_with( 'myapp' )
            .build( graphite )
      
          requests.mark
          reporter.start( 10, Leafy::Metrics::Reporter::MILLISECONDS )
          sleep 0.01
          reporter.stop 
          result = File.read( logfile )[ (log.size)..-1 ]
          expect( result ).to match /metrics-graphite-reporter-.-thread-1] WARN com.codahale.metrics.graphite.GraphiteReporter/
        ensure
          reporter.stop if reporter
        end
      end
    end
  end
end
