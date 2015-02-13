# Leafy-Rack

## installation

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

* instrumented class which is almost like a rack middleware but is threadsafe and is meant to be shared with **ALL** requests. with this sharing in can count the number of active requests.

* a collection of middleware

## serializers for health and metrics data

are using the internal API of ```Leafy::Health::Registry``` or ```Leafy::Metrics::Registry``` to ```run_health_checks``` or retrieve the collect metrics and produces the json representation of these data.

    registry = Leafy::Health::Registry.new
	json_writer = Leafy::Json::HealthWriter.new
	json_writer.to_json( registry.health.run_health_checks )

or

    registry = Leafy::Metrics::Registry.new
	json_writer = Leafy::Json::MetricsWriter.new
	json_writer.to_json( registry.metrics )

both json writers can take a second argument to generate pretty prints:

	json_writer.to_json( registry.health.run_health_checks, true )  
	json_writer.to_json( registry.metrics, true )

## instrumented http response

the class ```Leafy::Instrumented::Instrumented``` has a call method which expect a block. the block needs to return the usual rack middleware result ```[status, headers, body]```.

typical usage of this inside a rack-middleware

    metrics = Leafy::Metrics::Registry.new
    instrumented = Leafy::Instrumented::Instrumented.new( metrics, 'myapp' )
	instrumented.call do
       @app.call( env )
	end

see the ```Leafy::Rack::Instrumented``` for an example.

## rack middleware

* instrumented middleware collecting metrics on response status, response time, and active requests
* json data of metrics snapshot
* json data of current health
* ping
* java thread-dump
* admin page with links to metrics, health, ping and thread-dump data

### instrumented middleware

    metrics = Leafy::Metrics::Registry.new
    use Leafy::Rack::Instrumented, Leafy::Instrumented::Instrumented.new( metrics, 'webapp' )

note: when this instrumented middleware gets configured **after** any of the admin middleware (see below) then those admin requests are not going into the instrumented metrics.

### metrics middleware

json data of a snapshot of metrics are under the path **/metrics**

    metrics = Leafy::Metrics::Registry.new
    use Leafy::Rack::Metrics, metrics

or with custom path

    metrics = Leafy::Metrics::Registry.new
    use Leafy::Rack::Metrics, metrics, '/admin/metrics'

### health-checks middleware

json data of current health are under the path **/health**

    health = Leafy::Health::Registry.new
    use Leafy::Rack::Health, health

or with custom path

    health = Leafy::Health::Registry.new
    use Leafy::Rack::Health, health, '/admin/health'

### ping middleware

under the path **/ping**

    use Leafy::Rack::Ping

or with custom path

    use Leafy::Rack::Ping, '/admin/ping'

### java thread-dump middleware

under the path **/threads**

    use Leafy::Rack::ThreadDump

or with custom path

    use Leafy::Rack::ThreadDump, '/admin/threads'


### admin page middleware

a simple page with links to metrics, health, ping and thread-dump data under the path **/admin**

    metrics = Leafy::Metrics::Registry.new
    health = Leafy::Health::Registry.new

    use Leafy::Rack::Admin, metrics, health

or with custom path

    metrics = Leafy::Metrics::Registry.new
    health = Leafy::Health::Registry.new

    use Leafy::Rack::Admin, metrics, health, '/hidden/admin'

## example sinatra app

there is an [example sinatra application](https://github.com/lookout/leafy/tree/master/examples/hellowarld) which uses admin and instrumented middleware and adds some extra metrics inside the application.

## developement

get all the gems and jars in place

    gem install jar-dependencies --development
	bundle install

please make sure you are using jar-dependencies > 0.1.8 !

for running all specs

	rake

or

    rspec spec/reporter_spec.rb
