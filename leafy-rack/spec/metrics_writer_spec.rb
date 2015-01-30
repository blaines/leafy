require_relative 'setup'

require 'leafy-metrics'
require 'leafy/json/metrics_writer'
require 'yaml'
require 'json'

describe Leafy::Json::MetricsWriter do

  subject { Leafy::Json::MetricsWriter.new }

  let( :metrics ) do
    m = Leafy::Metrics::Registry.new
    m.register_meter( 'one' ).mark
    m.register_meter( 'two' ).mark
    c = m.register_counter( 'three' )
    c.inc
    c.inc
    m.metrics
  end

  let( :expected ) do
    {
      "two"=> {"count"=>1,
        "m15_rate"=>0.0,
        "m1_rate"=>0.0,
        "m5_rate"=>0.0,
        "units"=>"events/second"}, 
      "one"=> {"count"=>1, 
        "m15_rate"=>0.0, 
        "m1_rate"=>0.0, 
        "m5_rate"=>0.0, 
        "units"=>"events/second"}, 
      "three"=>{"count"=>2}
    }
  end

  it 'serializes metrics data to json' do
    data = subject.to_json( metrics.metrics )
    expect( data.count( "\n" ) ).to eq 0
    data = JSON.parse( data )
    expect( data['one'].delete('mean_rate') ).to be >0
    expect( data['two'].delete('mean_rate') ).to be >0
    expect( data.to_yaml ).to eq expected.to_yaml
  end

  it 'serializes metrics data to json (pretty print)' do
    data = subject.to_json( metrics.metrics, true )
    expect( data.count( "\n" ) ).to eq 20
    data = JSON.parse( data )
    expect( data['one'].delete('mean_rate') ).to be >0
    expect( data['two'].delete('mean_rate') ).to be >0
    expect( data.to_yaml ).to eq expected.to_yaml
  end
end
