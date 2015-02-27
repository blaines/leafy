require 'leafy/health'
require 'json'

describe Leafy::Health::Registry do

  subject { Leafy::Health::Registry.new }

  it 'registers and unregister check as block' do
    subject.register('me') do
      'error'
    end
    expect(subject.names).to eq ['me']

    results = subject.health.run_health_checks
    expect(results.keys).to eq ['me']

    first = results.values.to_array.first
    expect(first.message).to eq 'error'
    expect(first.healthy?).to eq false

    subject.unregister('me')
    expect(subject.names).to be_empty
  end

  it 'registers and unregister check as block using dsl' do
    subject.register('me') do
      healthy 'ok'
    end
    expect(subject.names).to eq ['me']

    results = subject.health.run_health_checks
    expect(results.keys).to eq ['me']

    first = results.values.to_array.first
    expect(first.message).to eq 'ok'
    expect(first.healthy?).to eq true

    subject.unregister('me')
    expect(subject.names).to be_empty
  end

  it 'registers and unregister check as HealthCheck with block' do
    subject.register('me',  Leafy::Health::HealthCheck.new {} )

    expect(subject.names).to eq ['me']

    results = subject.health.run_health_checks
    expect(results.keys).to eq ['me']

    first = results.values.to_array.first
    expect(first.message).to be_nil
    expect(first.healthy?).to eq true

    subject.unregister('me')
    expect(subject.names).to be_empty
  end

  it 'registers and unregister check as HealthCheck without implementing call' do
    subject.register('me',  Leafy::Health::HealthCheck.new )

    expect(subject.names).to eq ['me']

    results = subject.health.run_health_checks
    expect(results.keys).to eq ['me']

    first = results.values.to_array.first
    expect(first.message).to eq 'health check "call" method not implemented'
    expect(first.healthy?).to eq false
    
    subject.unregister('me')
    expect(subject.names).to be_empty
  end

  it 'fails register check as wrong object' do
    expect { subject.register('me', Object.new ) }.to raise_error
  end

  describe Leafy::Health::HealthCheck do

    it 'is healthy default with simple block' do
      check = Leafy::Health::HealthCheck.new do
        nil
      end
      expect( check.check.healthy? ).to be true
      expect( check.check.message ).to be nil
      expect( check.check.to_json ).to eq "{\"healthy\":true,\"message\":null}"
    end

    it 'is healthy with simple block' do
      check = Leafy::Health::HealthCheck.new do
        healthy 'happy'
      end
      expect( check.check.healthy? ).to be true
      expect( check.check.message ).to eq 'happy'
      expect( check.check.to_json ).to eq "{\"healthy\":true,\"message\":\"happy\"}"
    end

    it 'is healthy with structural message' do
      check = Leafy::Health::HealthCheck.new do
        healthy :msg => 'happy', :date => '11-11-2011'
      end
      expect( check.check.healthy? ).to be true
      expect( check.check.to_json ).to eq "{\"healthy\":true,\"message\":{\"msg\":\"happy\",\"date\":\"11-11-2011\"}}"
    end

    it 'is healthy default' do
      check = Leafy::Health::HealthCheck.new
      def check.call; nil; end
      expect( check.check.healthy? ).to be true
      expect( check.check.message ).to eq nil
    end

    it 'is healthy' do
      check = Leafy::Health::HealthCheck.new
      def check.call; healthy( 'ok' ); end
      expect( check.check.healthy? ).to be true
      expect( check.check.message ).to eq 'ok'
    end

    it 'is unhealthy default with simple block' do
      check = Leafy::Health::HealthCheck.new do
        'sick'
      end
      expect( check.check.healthy? ).to be false
      expect( check.check.message ).to eq 'sick'
    end

    it 'is unhealthy with simple block' do
      check = Leafy::Health::HealthCheck.new do
        unhealthy 'really sick'
      end
      expect( check.check.healthy? ).to be false
      expect( check.check.message ).to eq 'really sick'
    end

    it 'is unhealthy with structural message' do
      check = Leafy::Health::HealthCheck.new do
        unhealthy :msg => 'oh je', :date => '11-11-2011'
      end
      expect( check.check.healthy? ).to be false
      expect( check.check.to_json ).to eq "{\"healthy\":false,\"message\":{\"msg\":\"oh je\",\"date\":\"11-11-2011\"}}"
    end

    it 'is unhealthy default' do
      check = Leafy::Health::HealthCheck.new
      def check.call; 'not ok'; end
      expect( check.check.healthy? ).to be false
      expect( check.check.message ).to eq 'not ok'
    end

    it 'is unhealthy' do
      check = Leafy::Health::HealthCheck.new
      def check.call; unhealthy( 'not ok' ); end
      expect( check.check.healthy? ).to be false
      expect( check.check.message ).to eq 'not ok'
    end
  end
end
