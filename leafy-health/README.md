# Leafy-Health

## installation

via rubygems
```
gem install leafy-health
```
or add to your Gemfile
```
gem 'leafy-health'
```

installing the gem also takes care of the jar dependencies with jruby-1.7.16+

## usage

an instance of the registry ```Leafy::Health::Registry``` can register and unresgister health-checks under a given name. any object with a #call method will do or block on the register method.

     registry = Leafy::Health::Registry.new

you can ask the registry which names have already health-checks registered:

     registry.names

### simple health check

simple in the sense that either call returns ```nil``` which means healthy or a message which is the unhealthy state. the message can be any ```String```.
     
    registry.register( 'simple.block') do
      if app.crashed
        'application crashed'
      end
    end

or with a health-check object

    class AppCheck < Leafy::Health::HealthCheck
      def call
        if app.crashed
          'application crashed'
        end
      end
    end
    registry.register( 'simple.class', AppCheck.new )

### health checks with message on healthy state

here the call method gets an argument which allows to create both
healthy and unhealthy states with message.
         
    registry.register( 'app.block') do
      if app.crashed
        unhealthy( 'application crashed' )
      else
        healthy( 'application ok' )
      end
    end

or with a health-check object

    class AppCheck < Leafy::Health::HealthCheck
      def call
        if app.crashed
          unhealthy( 'application crashed' )
        else
          healthy( 'application ok' )
        end
      end
    end
    registry.register( 'app.class', AppCheck.new )

### health checks with structural data as message

    registry.register( 'app.block') do
      if app.crashed
        unhealthy( :host => 'localhost', :msg => 'not good' )
      else
        healthy( :host => 'localhost', :msg => 'application ok' )
      end
    end

or as health-check object

    class AppCheck < Leafy::Health::HealthCheck
      def call
        if app.crashed
          unhealthy( :host => 'localhost', :msg => 'application crashed' )
        else
          healthy( :host => 'localhost', :msg => 'application ok' )
        end
      end
    end
    registry.register( 'app.class', AppCheck.new )

### unregister health checks

    registry.unregister( 'app.class' )

### note

currently there is not further introspection on the registry and its health-check. with the ```Leafy::Json::HealthWriter``` (from leafy-rack) you can get a json representation of the current **health report**

    Leafy::Json::HealthWriter.to_json( registry.health )

## developement

get all the gems and jars in place

    gem install jar-dependencies --development
	bundle install

for running all specs

	rake

or

    rspec spec/reporter_spec.rb
