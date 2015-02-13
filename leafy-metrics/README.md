# Leafy-Metrics

## installation

via rubygems
```
gem install leafy-metrics
```
or add to your Gemfile
```
gem 'leafy-metrics'
```

installing the gem also takes care of the jar dependencies with jruby-1.7.16+

## usage

an instance of the registry ```Leafy::Metrics::Registry``` can register various metrics like gauge, timer, meter, counter and histogram and remove them again.

     registry = Leafy::Metrics::Registry.new

### gauge

it can be other a given block or any object with a #call method returning the gauge - a number
     
    registry.register_gauge( 'app.uptime') do
	  App.uptime
	end

or with an object

    class UptimeGauge
	  def call
	    App.uptime
      enf
	end
	registry.register_gauge( 'app.uptime', UptimeGauge.new )

### timer

a timer can measure the time an block needs to execute:

    timer = registry.register_timer( 'app.timer' )
	timer.time do
      App.update_data
    end

### counter

a counter simply counts i.e. can be incremented or decremented

    counter = registry.register_counter( 'active.users.counter' )

	# one new user logged on
	counter.inc
	
	# three new users logged on
	counter.inc 3
	
    # one user logged off
    counter.dec

    # two users logged off
    counter.dec 2

### meter

    used = registry.register_meter( 'app.used' )

mark the occurrence of an event

	used.mark

mark the occurrence of 'n' events

	used.mark n


### histogram

measures the distribution of values in a stream of data using an exponentially decaying reservoir

    histogram = registry.register_histogram( 'search.results' )
    histogram.update( Search.last_result.size )

### remove any metrics

    registry.unregister( 'app.uptime )

### note

currently there is not further introspection on the registry and its health-check. with the ```Leafy::Json::MetricsWriter``` (from leafy-rack) you can get a json representation of the current **metrics report**

    Leafy::Json::MetricsWriter.to_json( registry.metrics )

## reporters

all reporters use a builder pattern. there are following timeunits for
configuration:

* ```Leafy::Metrics::Reporter::DAYS```
* ```Leafy::Metrics::Reporter::HOURS```
* ```Leafy::Metrics::Reporter::MINUTES```
* ```Leafy::Metrics::Reporter::SECONDS```
* ```Leafy::Metrics::Reporter::MILLISECONDS```
* ```Leafy::Metrics::Reporter::MICROSECONDS```
* ```Leafy::Metrics::Reporter::NANOSECONDS```

in all examples below ```metrics = Leafy::Metrics::Registry.new```

### console reporter

    require 'leafy/metrics/console_reporter'
    reporter = Leafy::Metrics::ConsoleReporter.for_registry( metrics ).build
	reporter.start( 1, Leafy::Metrics::Reporter::SECONDS )
	....
	reporter.stop

or with all the possible configuration

	reporter = Leafy::Metrics::ConsoleReporter.for_registry( metrics )
	    .convert_rates_to( Leafy::Metrics::Reporter::MILLISECONDS )
        .convert_durations_to( Leafy::Metrics::Reporter::MILLISECONDS )
        .output_to( STDERR )
        .build

### csv reporter

for each metric there will be a CSV file inside a given directory

    require 'leafy/metrics/csv_reporter'
    reporter = Leafy::Metrics::CSVReporter.for_registry( metrics )
	    .build( 'metrics/directory' )
	reporter.start( 1, Leafy::Metrics::Reporter::SECONDS )
	....
	reporter.stop

or with all possible configuration

	reporter = Leafy::Metrics::CSVReporter.for_registry( metrics )
	    .convert_rates_to( Leafy::Metrics::Reporter::MILLISECONDS )
        .convert_durations_to( Leafy::Metrics::Reporter::MILLISECONDS )
        .build( 'metrics/directory' )

### graphite reporter

there are three targets where to send the data

* ```Leafy::Metrics::Graphite.new_tcp( hostname, port )```
* ```Leafy::Metrics::Graphite.new_udp( hostname, port )```
* ```Leafy::Metrics::Graphite.new_pickled( hostname, port, batchsize )```

the latter is collecting a few report event and sends them as batch. the ```sender``` is one of the above targets.

    require 'leafy/metrics/graphite_reporter'
    reporter = Leafy::Metrics::GraphiteReporter.for_registry( metrics )
	    .build( sender )
	reporter.start( 1, Leafy::Metrics::Reporter::SECONDS )
	....
	reporter.stop

or with full configuration

	reporter = Leafy::Metrics::GraphiteReporter.for_registry( metrics )
	    .convert_rates_to( Leafy::Metrics::Reporter::MILLISECONDS )
        .convert_durations_to( Leafy::Metrics::Reporter::MILLISECONDS )
		.prefixed_with( 'myapp' )
        .build( sender )

## developement

get all the gems and jars in place

    gem install jar-dependencies --development
	bundle install

for running all specs

	rake

or

    rspec spec/reporter_spec.rb
