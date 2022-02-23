# frozen_string_literal: true

module Ksql
  module Handlers
    class Raw
      #
      # Return the Response raw parsed body
      #
      # @param [Ksql::Connection::Response] response HTTP2 Request response
      #
      # @return [Array/Hash/String/Integer] Response parsed body
      #
      def self.handle(response)
        return Ksql::Error.new(response.body) if response.error?

        response.body
      end
    end
  end
end
