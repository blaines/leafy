# show case for leafy gems

get all the gems in place

	gem install jar-dependencies --development
    bundle install

## starting the server

### with jetty

    rmvn jetty:run

the urls:

    [http://localhost:8080/app](http://localhost:8080/app)
    [http://localhost:8080/admin](http://localhost:8080/admin)

### with tomcat or wildfly

	rmvn tomcat:run
	rmvn wildfly:run

the urls:

    [http://localhost:8080/hellowarld/app](http://localhost:8080/hellowarld/app)
    [http://localhost:8080/hellowarld/admin](http://localhost:8080/hellowarld/admin)

## configurations

* Mavenfile
* WEB-INF/web.xml

## run some integration test

    rmvn verify

or

    rake

with jruby-9k due to some bundler bug you need to run (not needed with rvm)

    BUNDLE_DISABLE_SHARED_GEMS=true rake
