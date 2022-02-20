# frozen_string_literal: true

module Ksql
  module Query
    class Buffer
      attr_accessor :buffer, :struct

      def initialize(buffer: [], permanent: false, struct: nil)
        @buffer = buffer
        @permanent = permanent
        @struct = struct
      end

      def define_struct(const_name, attributes:)
        @struct = Ksql.const_set(const_name, Class.new(Struct.new(*attributes)))
      end

      def struct_instance(attributes)
        result = @struct.new(*attributes)
        @buffer << result if @permanent

        result
      end
    end
  end
end
