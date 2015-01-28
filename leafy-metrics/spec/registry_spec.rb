require 'leafy-metrics'

describe Leafy::Metrics::Registry do

  subject { Leafy::Metrics::Registry.new }

  it 'registers and unregister a meter' do
    obj = subject.register_meter('me')
    expect(obj).to be_a(Java::ComCodahaleMetrics::Meter)
    expect(subject.metrics.meters['me']).to be obj
    expect(obj.respond_to? :mark).to be true

    subject.remove('me')
    expect(subject.metrics.meters).to be_empty
  end

  it 'registers and unregister a counter' do
    obj = subject.register_counter('me')
    expect(obj).to be_a(Java::ComCodahaleMetrics::Counter)
    expect(subject.metrics.counters['me']).to be obj
    expect(obj.respond_to? :inc).to be true
    expect(obj.respond_to? :dec).to be true

    subject.remove('me')
    expect(subject.metrics.counters).to be_empty
  end

  it 'registers and unregister a histogram' do
    obj = subject.register_histogram('me')
    expect(obj).to be_a(Java::ComCodahaleMetrics::Histogram)
    expect(subject.metrics.histograms['me']).to be obj
    expect(obj.respond_to? :update).to be true

    subject.remove('me')
    expect(subject.metrics.histograms).to be_empty
  end

  it 'registers and unregister a timer' do
    obj = subject.register_timer('me')
    expect(obj).to be_a(Leafy::Metrics::Registry::Timer)
    expect(subject.metrics.timers['me']).to be obj.timer
    expect(obj.timer.respond_to? :time).to be true

    subject.remove('me')
    expect(subject.metrics.timers).to be_empty
  end

  it 'registers and unregister gauge as block' do
    obj = subject.register_gauge('me') do
      123
    end
    expect(obj).to be_a(Leafy::Metrics::Registry::Gauge)
    expect(subject.metrics.gauges['me']).to be obj
    expect(obj.value).to eq 123

    subject.remove('me')
    expect(subject.metrics.gauges).to be_empty
  end

  it 'registers and unregister gauge as object with call method' do
    obj = subject.register_gauge('me', Proc.new do
      123
    end )
    expect(obj).to be_a(Leafy::Metrics::Registry::Gauge)
    expect(subject.metrics.gauges['me']).to be obj
    expect(obj.value).to eq 123

    subject.remove('me')
    expect(subject.metrics.gauges).to be_empty
  end

  it 'fails register gauge as object without call method' do
    expect { subject.register_gauge('me', Object.new ) }.to raise_error
  end

  describe Leafy::Metrics::Registry::Timer do

    it 'can messure duration' do
      obj = subject.register_timer('me')
      expect(obj.timer.mean_rate).to eq 0.0

      obj.time do
        sleep 0.1
      end
      
      expect(obj.timer.mean_rate).to be > 0.0

      subject.remove('me')
    end
  end
end
