require_relative 'setup'

require 'leafy/instrumented/instrumented'
require 'rack/leafy/instrumented'

describe Rack::Leafy::Instrumented do

  subject { Rack::Leafy::Instrumented.new( app, instrumented ) }
 
  let( :instrumented ) { Leafy::Instrumented::Instrumented.new( registry, "name" ) }
 
  let( :registry ) { Leafy::Metrics::Registry.new }

  let( :status ) { (Random.rand * 500 + 100).to_i }
    
  let( :random ) { Random.rand.to_s }
    
  let( :app ) do
    Proc.new do
      [ status, {}, [ random ] ]
    end
  end

  it "collects metrics for a call and pass result on" do
    result, _, body = subject.call( {} )
    expect( result ).to eq status
    expect( body.join ).to eq random

    expect( registry.metrics.timers.keys ).to eq [ 'name.requests' ] 
    expect( registry.metrics.timers.values.first.mean_rate ).to be > 0.09

    expect( registry.metrics.counters.keys ).to eq [ 'name.active_requests' ] 
    expect( registry.metrics.counters.values.collect { |a| a.count } ).to eq [ 0 ]

    expect( registry.metrics.meters.values.select{ |a| a.count == 0 }.size ).to eq 7
    expect( registry.metrics.meters.values.select{ |a| a.count == 1 }.size ).to eq 1
  end
end
