# frozen_string_literal: true

# TODO DOC

module Ksql
  module Handlers
    class Collection
      #
      # Handle the response to generate an Enumerable collection
      #
      # @param [Ksql::Connection::Response] response HTTP2 Request response
      #
      # @return [Ksql::Collection] Collection result
      #
      def self.handle(response)
        return Ksql::Error.new(response.body) if response.error?

        body_dup = response.body
        headers = body_dup.shift
        Ksql::Collection.new(headers, body_dup)
      end
    end
  end
end
