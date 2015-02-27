require_relative 'setup'

require 'leafy/rack/health'
require 'yaml'
require 'json'

describe Leafy::Rack::Health do

  subject { Leafy::Rack::Health }

  let( :registry ) { Leafy::Health::Registry.new }

  let( :expected_headers ) do
    { 'Content-Type' => 'application/json',
      'Cache-Control' => 'must-revalidate,no-cache,no-store' }
  end

  let( :result ){ [ 200, nil, [] ] }
  let( :app ) do
    Proc.new() { result }
  end

  describe 'healthy' do

    let( :health ) do
      m = registry
      m.register( 'two' ) do |ctx|
        ctx.healthy 'ok'
      end
      m.health
    end
    let( :report ) do
      { 'two' => { 'healthy' => true, 'message' => 'ok' } }
    end

    it 'has response' do
      status, headers, body = subject.response( health, {} )
      expect( status ).to eq 200
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      body = JSON.parse( body.join )
      expect( body.to_yaml ).to eq report.to_yaml
    end

    it 'has pretty response' do
      status, headers, body = subject.response( health, { 'QUERY_STRING' => 'pretty' } )
      expect( status ).to eq 200
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      expect( body.join.count( "\n" ) ).to eq 5
      body = JSON.parse( body.join )
      expect( body.to_yaml ).to eq report.to_yaml
    end
  end

  describe 'unhealthy' do
    let( :health ) do
      m = registry
      m.register( 'one' ) do |ctx|
        'error'
      end
      m.health
    end

    let( :report ) do
      { 'one' => { 'healthy' => false, 'message' => 'error' } }
    end

    it 'has response' do
      status, headers, body = subject.response( health, {} )
      expect( status ).to eq 503
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      body = JSON.parse( body.join )
      expect( body.to_yaml ).to eq report.to_yaml
    end

    it 'has pretty response' do
      status, headers, body = subject.response( health, { 'QUERY_STRING' => 'pretty' } )
      expect( status ).to eq 503
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      expect( body.join.count( "\n" ) ).to eq 5
      body = JSON.parse( body.join )
      expect( body.to_yaml ).to eq report.to_yaml
    end
  end

  describe 'default path' do
    subject { Leafy::Rack::Health.new( app, registry ) }

    it 'passes request if not matches the given path' do
      env = { 'PATH_INFO'=> '/something' }
      expect( subject.call( env ) ).to eq result
    end

    it 'reports health-checks on health path' do
      env = { 'PATH_INFO'=> '/health' }
      status, headers, body = subject.call( env )
      expect( status ).to eq 200
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      expect( body.join ).to eq '{}'
    end

    it 'reports "pretty" health-checks on health path' do
      env = { 'PATH_INFO'=> '/health', 'QUERY_STRING' => 'pretty' }
      status, headers, body = subject.call( env )
      expect( status ).to eq 200
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      expect( body.join.gsub( /\s/m, '' ) ).to eq '{}'
    end
  end

  describe 'custom path' do
    subject { Leafy::Rack::Health.new( app, registry, '/custom' ) }

    it 'passes request if not matches the given path' do
      env = { 'PATH_INFO'=> '/something' }
      expect( subject.call( env ) ).to eq result
      env = { 'PATH_INFO'=> '/health' }
      expect( subject.call( env ) ).to eq result
    end

    it 'reports health-checks on health path' do
      env = { 'PATH_INFO'=> '/custom' }
      status, headers, body = subject.call( env )
      expect( status ).to eq 200
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      expect( body.join ).to eq '{}'
    end

    it 'reports "pretty" health-checks on health path' do
      env = { 'PATH_INFO'=> '/custom', 'QUERY_STRING' => 'pretty' }
      status, headers, body = subject.call( env )
      expect( status ).to eq 200
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      expect( body.join.gsub( /\s/m, '' ) ).to eq '{}'
    end
  end
end
