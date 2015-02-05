require_relative 'setup'

require 'leafy/rack/metrics'
require 'yaml'
require 'json'

describe Leafy::Rack::Metrics do

  subject { Leafy::Rack::Metrics }

  let( :registry ) { Leafy::Metrics::Registry.new }

  let( :expected_headers ) do
    { 'Content-Type' => 'application/json',
      'Cache-Control' => 'must-revalidate,no-cache,no-store' }
  end
  let( :report ) do
    { 'version' => '3.0.0',
      'gauges' => {},
      'counters' => {},
      'histograms' => {},
      'meters' => {},
      'timers' =>  {}
    }
  end

  let( :result ){ [ 200, nil, [] ] }
  let( :app ) do
    Proc.new() { result }
  end

  it 'has response' do
    status, headers, body = subject.response( registry.metrics, {} )
    expect( status ).to eq 200
    expect( headers.to_yaml).to eq expected_headers.to_yaml
    expect( body.join.count( "\n" ) ).to eq 0
    body = JSON.parse( body.join )
    expect( body.to_yaml ).to eq report.to_yaml
  end

  it 'has pretty response' do
    status, headers, body = subject.response( registry.metrics,
                                              { 'QUERY_STRING' => 'pretty' } )
    expect( status ).to eq 200
    expect( headers.to_yaml).to eq expected_headers.to_yaml
    expect( body.join.count( "\n" ) ).to eq 7
    body = JSON.parse( body.join )
    expect( body.to_yaml ).to eq report.to_yaml
  end

  describe 'default path' do
    subject { Leafy::Rack::Metrics.new( app, registry ) }

    it 'passes request if not matches the given path' do
      env = { 'PATH_INFO'=> '/something' }
      expect( subject.call( env ) ).to eq result
    end

    it 'reports metricss on metrics path' do
      env = { 'PATH_INFO'=> '/metrics' }
      status, headers, body = subject.call( env )
      expect( status ).to eq 200
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      expect( body.join.count( "\n" ) ).to eq 0
      body = JSON.parse(body.join)
      expect( body.to_yaml ).to eq report.to_yaml
    end

    it 'reports "pretty" health-checks on health path' do
      env = { 'PATH_INFO'=> '/metrics', 'QUERY_STRING' => 'pretty' }
      status, headers, body = subject.call( env )
      expect( status ).to eq 200
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      expect( body.join.count( "\n" ) ).to eq 7
      body = JSON.parse(body.join)
      expect( body.to_yaml ).to eq report.to_yaml
    end
  end

  describe 'custom path' do
    subject { Leafy::Rack::Metrics.new( app, registry, '/custom' ) }

    it 'passes request if not matches the given path' do
      env = { 'PATH_INFO'=> '/something' }
      expect( subject.call( env ) ).to eq result
      env = { 'PATH_INFO'=> '/metrics' }
      expect( subject.call( env ) ).to eq result
    end

    it 'reports metricss on metrics path' do
      env = { 'PATH_INFO'=> '/custom' }
      status, headers, body = subject.call( env )
      expect( status ).to eq 200
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      expect( body.join.count( "\n" ) ).to eq 0
      body = JSON.parse(body.join)
      expect( body.to_yaml ).to eq report.to_yaml
    end

    it 'reports "pretty" health-checks on health path' do
      env = { 'PATH_INFO'=> '/custom', 'QUERY_STRING' => 'pretty' }
      status, headers, body = subject.call( env )
      expect( status ).to eq 200
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      expect( body.join.count( "\n" ) ).to eq 7
      body = JSON.parse(body.join)
      expect( body.to_yaml ).to eq report.to_yaml
    end
  end
end
