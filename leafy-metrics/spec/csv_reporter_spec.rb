require_relative 'setup'
require 'leafy/metrics/csv_reporter'
require 'fileutils'

describe Leafy::Metrics::CSVReporter do

  subject { Leafy::Metrics::CSVReporter }

  let( :metrics ) { Leafy::Metrics::Registry.new }
  let( :requests ) { metrics.register_meter( "requests" ) }
  let( :csvfile ) { File.expand_path( File.dirname( __FILE__ ) ) + "/tmp/requests.csv" }
  let( :tmpdir ) do
    dir = File.expand_path( File.dirname( csvfile ) )
    FileUtils.mkdir_p( dir )
    FileUtils.rm_f( csvfile )
    dir
  end
  
  it 'run reporter with defaults' do
    begin
      reporter = subject.for_registry( metrics ).build( tmpdir )
      requests.mark
      reporter.start( 10, Leafy::Metrics::Reporter::MILLISECONDS )
      sleep 0.01
      reporter.stop
      result = File.read( csvfile )
      expect( result ).to match /t,count,mean_rate,m1_rate,m5_rate,m15_rate,rate_unit/
      expect( result ).to match /second/
    ensure
      FileUtils.rm_rf( tmpdir )
      reporter.stop if reporter
    end
  end

  it 'run reporter' do
    begin
      reporter = subject.for_registry( metrics )
        .convert_rates_to( Leafy::Metrics::Reporter::MILLISECONDS )
        .convert_durations_to( Leafy::Metrics::Reporter::MILLISECONDS )
        .build( tmpdir )

      requests.mark
      reporter.start( 10, Leafy::Metrics::Reporter::MILLISECONDS )
      sleep 0.01
      reporter.stop 
      result = File.read( csvfile )
      expect( result ).to match /t,count,mean_rate,m1_rate,m5_rate,m15_rate,rate_unit/
      expect( result ).to match /second/
    ensure
      FileUtils.rm_rf( tmpdir )
      reporter.stop if reporter
    end
  end

end
