# Leafy-Metrics

## install

via rubygems
```
gem install leafy-metrics
```
or add to your Gemfile
```
gem 'leqfy-metrics'
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
