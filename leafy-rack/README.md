# Leafy-Rack

## install

via rubygems
```
gem install leafy-rack
```
or add to your Gemfile
```
gem 'leafy-rack
```

installing the gem also takes care of the jar dependencies with jruby-1.7.16+

## intro

there actually three parts to this gem

* serializers to write out json data from the collected data of ```Leafy::Health::Registry``` and ```Leafy::Metrics::Registry```

* instrumented class which is almost like a rack middleware but is threadsafe and is meant to be shared with **ALL** requests

* a collection of middleware

## serializers for health and metrics data

are using the internal API ```.health.run_health_checks``` and ```Leafy::Metrics::Registry.new.metrics``` to produce the json representation of these data.

    registry = Leafy::Health::Registry.new
	json_writer = Leafy::Json::HealthWriter.new
	json_writer.to_json( registry.health.run_health_checks )

or

    registry = Leafy::Metrics::Registry.new
	json_writer = Leafy::Json::MetricsWriter.new
	json_writer.to_json( registry.metrics )

both json writers can take a second argument to generate pretty prints:

	json_writer.to_json( registry.health.run_health_checks, true )

or
  
	json_writer.to_json( registry.metrics, true )

## instrumented http response

the class ```Leafy::Instrumented::Instrumented``` has a call method which expect a block which returns the usual rack middleware result ```[status, headers, body]```.

typical usage of this:

    metrics = Leafy::Metrics::Registry.new
    instrumented = Leafy::Instrumented::Instrumented.new( metrics, 'myapp' )
	instrumented.call do
       @app.call( env )
	end

## rack middleware

* instrumented middleware collecting metrics on response status, response time, and active requests
* json data of metrics snapshot
* json data of current health
* ping
* java thread-dump
* admin page with links to metrics, health, ping and thread-dump data

### instrumented middleware

    metrics = Leafy::Metrics::Registry.new
    use Rack::Leafy::Instrumented, Leafy::Instrumented::Instrumented.new( metrics, 'webapp' )

note: when this instrumented middleware gets configured **after** any of the comming admin middleware then those admin requests are not going into the instrumented metrics.

### json data of metrics snapshot

under the path **/metrics**

    metrics = Leafy::Metrics::Registry.new
    use Rack::Leafy::Metrics, metrics

or with custom path

    metrics = Leafy::Metrics::Registry.new
    use Rack::Leafy::Metrics, metrics, '/admin/metrics'

### json data of current health

under the path **/health**

    health = Leafy::Health::Registry.new
    use Rack::Leafy::Health, health

or with custom path

    health = Leafy::Health::Registry.new
    use Rack::Leafy::Health, health, '/admin/health'

### ping

under the path **/ping**

    use Rack::Leafy::Ping

or with custom path

    use Rack::Leafy::Ping, '/admin/ping'

### java thread-dump

under the path **/threads**

    use Rack::Leafy::ThreadDump

or with custom path

    use Rack::Leafy::ThreadDump, '/admin/threads'


### admin page

a page with links to metrics, health, ping and thread-dump data under the path **/admin**

    metrics = Leafy::Metrics::Registry.new
    health = Leafy::Health::Registry.new

    use Rack::Leafy::Admin, metrics, health

or with custom path

    metrics = Leafy::Metrics::Registry.new
    health = Leafy::Health::Registry.new

    use Rack::Leafy::Admin, metrics, health, '/hidden/admin'

## example sinatra app

there is an [example sinatra application](https://github.com/lookout/leafy/tree/master/examples/hellowarld) which uses admin and instrumented middleware and adds some extra metrics inside the application.
