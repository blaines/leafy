java_import com.fasterxml.jackson.databind.ObjectMapper

module Leafy
  module Json
    class JsonWriter

      def initialize( jacksonModule )
        @mapper = ObjectMapper.new.registerModule( jacksonModule )
      end

      def data
        raise 'need implementation'
      end

      def to_json( data, pretty = false )
        # TODO make this stream
        output = java.io.ByteArrayOutputStream.new
        writer( pretty ).writeValue(output, data);
        output.to_s
      end
  
      private
  
      def writer( pretty )
        if pretty
          @mapper.writerWithDefaultPrettyPrinter
        else
          @mapper.writer
        end
      end
    end
  end
end
