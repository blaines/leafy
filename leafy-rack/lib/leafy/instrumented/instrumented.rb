require 'leafy/instrumented/basic_instrumented'

module Leafy
  module Instrumented
    class Instrumented < BasicInstrumented

      OK = 200;
      CREATED = 201;
      NO_CONTENT = 204;
      RESET_CONTENT = 205;
      BAD_REQUEST = 400;
      NOT_FOUND = 404;
      SERVER_ERROR = 500;

      def initialize( registry, name )
        super( registry, name,
               { OK => "#{NAME_PREFIX}.ok",
                 CREATED => "#{NAME_PREFIX}.created",
                 NO_CONTENT => "#{NAME_PREFIX}.noContent",
                 RESET_CONTENT => "#{NAME_PREFIX}.resetContent",
                 BAD_REQUEST => "#{NAME_PREFIX}.badRequest",
                 NOT_FOUND => "#{NAME_PREFIX}.notFound",
                 SERVER_ERROR => "#{NAME_PREFIX}.serverError" } )
      end
    end
  end
end
