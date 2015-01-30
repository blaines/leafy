require_relative 'setup'

require 'rack/leafy/admin'
require 'yaml'
require 'json'

describe Rack::Leafy::Admin do

  subject { Rack::Leafy::Admin }
  
  let( :expected_headers ) do
    { 'Content-Type' => 'text/html' }
  end

  let( :metrics ) { Leafy::Metrics::Registry.new }

  let( :health ) { Leafy::Health::Registry.new }

  let( :health_report ) do
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
    status, headers, body = subject.response( "/path" )
    expect( status ).to eq 200
    expect( headers.to_yaml).to eq expected_headers.to_yaml
    expect( body.join.count("\n" ) ).to eq 15
    expect( body.join.gsub( '/path/' ).collect { |f| f }.size ).to eq 6
  end

  describe 'default path' do
    subject { Rack::Leafy::Admin.new( app, metrics, health ) }

    it 'passes request if not matches the given path' do
      env = { 'PATH_INFO'=> '/something' }
      expect( subject.call( env ) ).to eq result
    end

    it 'shows menu page on admin path' do
      env = { 'PATH_INFO'=> '/admin' }
      status, headers, body = subject.call( env )
      expect( status ).to eq 200
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      expect( body.join.count("\n" ) ).to eq 15
    end

    it 'pongs on ping path' do
      env = { 'PATH_INFO'=> '/admin/ping' }
      status, _, body = subject.call( env )
      expect( status ).to eq 200
      expect( body.join ).to eq 'pong'
    end

    it 'thread dump on threads path' do
      env = { 'PATH_INFO'=> '/admin/threads' }
      status, _, body = subject.call( env )
      expect( status ).to eq 200
      expect( body.join.count( "\n" ) ).to be > 100
    end

    it 'reports metrics on metrics path' do
      env = { 'PATH_INFO'=> '/admin/metrics' }
      status, _, body = subject.call( env )
      expect( status ).to eq 200
      expect( body.join.count( "\n" ) ).to eq 0
      body = JSON.parse(body.join)
      expect( body.to_yaml ).to eq health_report.to_yaml
    end

    it 'reports health-checks on health path' do
      env = { 'PATH_INFO'=> '/admin/health' }
      status, _, body = subject.call( env )
      expect( status ).to eq 200
      expect( body.join.count( "\n" ) ).to eq 0
      body = JSON.parse(body.join)
      expect( body.to_yaml ).to eq "--- {}\n"
    end
  end

  describe 'custom path' do
    subject { Rack::Leafy::Admin.new( app, metrics, health, '/custom' ) }

    it 'passes request if not matches the given path' do
      env = { 'PATH_INFO'=> '/something' }
      expect( subject.call( env ) ).to eq result
      env = { 'PATH_INFO'=> '/ping' }
      expect( subject.call( env ) ).to eq result
    end

    it 'shows menu page on admin path' do
      env = { 'PATH_INFO'=> '/custom' }
      status, headers, body = subject.call( env )
      expect( status ).to eq 200
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      expect( body.join.count("\n" ) ).to eq 15
    end

    it 'pongs on ping path' do
      env = { 'PATH_INFO'=> '/custom/ping' }
      status, _, body = subject.call( env )
      expect( status ).to eq 200
      expect( body.join ).to eq 'pong'
    end

    it 'thread dump on threads path' do
      env = { 'PATH_INFO'=> '/custom/threads' }
      status, _, body = subject.call( env )
      expect( status ).to eq 200
      expect( body.join.count( "\n" ) ).to be > 100
    end

    it 'reports metrics on metrics path' do
      env = { 'PATH_INFO'=> '/custom/metrics' }
      status, _, body = subject.call( env )
      expect( status ).to eq 200
      expect( body.join.count( "\n" ) ).to eq 0
      body = JSON.parse(body.join)
      expect( body.to_yaml ).to eq health_report.to_yaml
    end

    it 'reports health-checks on health path' do
      env = { 'PATH_INFO'=> '/custom/health' }
      status, _, body = subject.call( env )
      expect( status ).to eq 200
      expect( body.join.count( "\n" ) ).to eq 0
      body = JSON.parse(body.join)
      expect( body.to_yaml ).to eq "--- {}\n"
    end
  end
end
