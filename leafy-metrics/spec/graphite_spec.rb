require_relative 'setup'
require 'leafy/metrics/graphite/graphite'

describe Leafy::Metrics::Graphite do

  subject { Leafy::Metrics::Graphite }

  it 'fails to create an instance without proper sender' do
    expect { subject.new Object.new }.to raise_error RuntimeError
  end

  it 'creates tcp graphite' do
    expect( subject.new_tcp( 'localhost', 123 ) ).not_to be_nil
  end

  it 'creates udp graphite' do
    expect( subject.new_udp( 'localhost', 123 ) ).not_to be_nil
  end

  it 'creates pickled graphite' do
    expect( subject.new_pickled( 'localhost', 123, 456 ) ).not_to be_nil
  end
end
