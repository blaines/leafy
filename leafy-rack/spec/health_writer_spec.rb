require_relative 'setup'

require 'leafy-health'
require 'leafy/json/health_writer'
require 'yaml'
require 'json'

describe Leafy::Json::HealthWriter do

  subject { Leafy::Json::HealthWriter.new }

  let( :health ) do
    m = Leafy::Health::Registry.new
    m.register( 'one' ) do
      'error'
    end
    m.register( 'two' ) do |ctx|
      ctx.healthy 'ok'
    end
    m.register( 'three' ) do |ctx|
      ctx.unhealthy 'no ok'
    end
    m.health
  end

  let( :expected ) do
    {
      "one"=> {"healthy"=>false, "message"=>"error"},
      "three"=>{"healthy"=>false, "message"=>"no ok"},
      "two"=>{"healthy"=>true, "message"=>"ok"}
    }
  end

  it 'serializes health-check data to json' do
    data = subject.to_json( health.run_health_checks )
    expect( data.count( "\n" ) ).to eq 0
    data = JSON.parse( data )
    expect( data.to_yaml ).to eq expected.to_yaml
  end

  it 'serializes health-check data to json (pretty print)' do
    data = subject.to_json( health.run_health_checks, true )
    expect( data.count( "\n" ) ).to eq 13
    data = JSON.parse( data )
    expect( data.to_yaml ).to eq expected.to_yaml
  end
end
