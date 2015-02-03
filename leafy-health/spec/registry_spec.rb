require 'leafy-health'

describe Leafy::Health::Registry do

  subject { Leafy::Health::Registry.new }

  it 'registers and unregister check as block' do
    subject.register('me') do
      'error'
    end
    expect(subject.names).to eq ['me']
    expect(subject.health.run_health_checks.keys).to eq ['me']

    subject.unregister('me')
    expect(subject.names).to be_empty
  end

  it 'registers and unregister check as object with call method' do
    subject.register('me', Proc.new {} )
    expect(subject.names).to eq ['me']
    expect(subject.health.run_health_checks.keys).to eq ['me']
    
    subject.unregister('me')
    expect(subject.names).to be_empty
  end

  it 'fails register check as object without call method' do
    expect { subject.register('me', Object.new ) }.to raise_error
  end

  describe Leafy::Health::Registry::HealthCheck do

    it 'is healthy with simple block' do
      check = Leafy::Health::Registry::HealthCheck.new( Proc.new { nil } )
      expect( check.check.healthy? ).to be true
      expect( check.check.message ).to be nil
    end

    it 'is healthy' do
      checker = Proc.new do |health|
        health.healthy( 'ok' )
      end
      check = Leafy::Health::Registry::HealthCheck.new( checker )
      expect( check.check.healthy? ).to be true
      expect( check.check.message ).to eq 'ok'
    end

    it 'is unhealthy with simple block' do
      check = Leafy::Health::Registry::HealthCheck.new( Proc.new { 'sick' } )
      expect( check.check.healthy? ).to be false
      expect( check.check.message ).to eq 'sick'
    end

    it 'is unhealthy' do
      checker = Proc.new do |health|
        health.unhealthy( 'not ok' )
      end
      check = Leafy::Health::Registry::HealthCheck.new( checker )
      expect( check.check.healthy? ).to be false
      expect( check.check.message ).to eq 'not ok'
    end
  end
end
