require_relative 'setup'

require 'leafy/rack/ping'
require 'yaml'
require 'json'

describe Leafy::Rack::Ping do

  subject { Leafy::Rack::Ping }
  
  let( :expected_headers ) do
    { 'Content-Type' => 'text/plain',
      'Cache-Control' => 'must-revalidate,no-cache,no-store' }
  end

  let( :result ){ [ 200, nil, [] ] }
  let( :app ) do
    Proc.new() { result }
  end

  it 'has response' do
    status, headers, body = subject.response
    expect( status ).to eq 200
    expect( headers.to_yaml).to eq expected_headers.to_yaml
    expect( body ).to eq ['pong']
  end

  describe 'default path' do
    subject { Leafy::Rack::Ping.new( app ) }

    it 'passes request if not matches the given path' do
      env = { 'PATH_INFO'=> '/something' }
      expect( subject.call( env ) ).to eq result
    end

    it 'pongs on ping path' do
      env = { 'PATH_INFO'=> '/ping' }
      status, headers, body = subject.call( env )
      expect( status ).to eq 200
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      expect( body ).to eq ['pong']
    end
  end

  describe 'custom path' do
    subject { Leafy::Rack::Ping.new( app, '/custom' ) }

    it 'passes request if not matches the given path' do
      env = { 'PATH_INFO'=> '/something' }
      expect( subject.call( env ) ).to eq result
      env = { 'PATH_INFO'=> '/ping' }
      expect( subject.call( env ) ).to eq result
    end

    it 'pongs on ping path' do
      env = { 'PATH_INFO'=> '/custom' }
      status, headers, body = subject.call( env )
      expect( status ).to eq 200
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      expect( body ).to eq ['pong']
    end
  end
end
