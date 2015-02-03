require 'jar_dependencies'
JBUNDLER_LOCAL_REPO = Jars.home
JBUNDLER_JRUBY_CLASSPATH = []
JBUNDLER_JRUBY_CLASSPATH.freeze
JBUNDLER_TEST_CLASSPATH = []
JBUNDLER_TEST_CLASSPATH.freeze
JBUNDLER_CLASSPATH = []
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/com/fasterxml/jackson/core/jackson-annotations/2.4.0/jackson-annotations-2.4.0.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/com/fasterxml/jackson/core/jackson-core/2.4.2/jackson-core-2.4.2.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/bouncycastle/bcprov-jdk15on/1.47/bcprov-jdk15on-1.47.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/slf4j/slf4j-api/1.7.7/slf4j-api-1.7.7.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/io/dropwizard/metrics/metrics-jvm/3.1.0/metrics-jvm-3.1.0.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/org/bouncycastle/bcpkix-jdk15on/1.47/bcpkix-jdk15on-1.47.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/io/dropwizard/metrics/metrics-core/3.1.0/metrics-core-3.1.0.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/com/fasterxml/jackson/core/jackson-databind/2.4.2/jackson-databind-2.4.2.jar')
JBUNDLER_CLASSPATH << (JBUNDLER_LOCAL_REPO + '/io/dropwizard/metrics/metrics-json/3.1.0/metrics-json-3.1.0.jar')
JBUNDLER_CLASSPATH.freeze
