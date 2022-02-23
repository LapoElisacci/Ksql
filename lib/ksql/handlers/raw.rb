# frozen_string_literal: true

# TODO DOC

module Ksql
  module Handlers
    class Raw
      def self.handle(response)
        return Ksql::Error.new(response.body) if response.error?

        response.body
      end
    end
  end
end
