# frozen_string_literal: true

# TODO DOC

module Ksql
  module Handlers
    class Collection
      def self.handle(response)
        return Ksql::Error.new(response.body) if response.error?

        body_dup = response.body
        headers = body_dup.shift
        Ksql::Collection.new(headers, body_dup)
      end
    end
  end
end
