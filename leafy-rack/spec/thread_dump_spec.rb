require_relative 'setup'

require 'leafy/rack/thread_dump'
require 'yaml'
require 'json'

describe Leafy::Rack::ThreadDump do

  subject { Leafy::Rack::ThreadDump }
  
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
    expect( body.join.count( "\n" ) ).to be > 100
  end

  describe 'default path' do
    it 'passes request if not matches the given path' do
      env = { 'PATH_INFO'=> '/something' }
      expect( subject.new( app ).call( env ) ).to eq result
    end

    it 'thread dump on threads path' do
      env = { 'PATH_INFO'=> '/threads' }
      status, headers, body = subject.new( app ).call( env )
      expect( status ).to eq 200
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      expect( body.join.count( "\n" ) ).to be > 100
    end
  end

  describe 'custom path' do
    it 'passes request if not matches the given path' do
      env = { 'PATH_INFO'=> '/something' }
      expect( subject.new( app, '/custom' ).call( env ) ).to eq result
      env = { 'PATH_INFO'=> '/threads' }
      expect( subject.new( app, '/custom' ).call( env ) ).to eq result
    end

    it 'thread dump on threads path' do
      env = { 'PATH_INFO'=> '/custom' }
      status, headers, body = subject.new( app, '/custom' ).call( env )
      expect( status ).to eq 200
      expect( headers.to_yaml).to eq expected_headers.to_yaml
      expect( body.join.count( "\n" ) ).to be > 100
    end
  end
end
