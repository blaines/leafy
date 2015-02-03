# show case to use PATCH verb with jruby-rack #

get all the gems in place

    bundle install

## with ruby-maven ##

run the application in a webserver like jetty

    rmvn jetty:run

via

    <http://localhost:8080/app>

the metrics are here:

    <http://localhost:8080/metrics?pretty=true>

or a current thread dump

    <http://localhost:8080/threads>

or choose one of those:

	rmvn tomcat:run
	rmvn wildfly:run

they are all configured to be accessible with the baseurl:

    <http://localhost:8080/hellowarld>

## config

* Mavenfile
* WEB-INF/web,xml
