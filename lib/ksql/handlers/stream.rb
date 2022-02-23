# frozen_string_literal: true

# TODO DOC

module Ksql
  module Handlers
    class Stream
      def self.handle(client, request)
        ::Ksql::Stream.new(client, request)
      end
    end
  end
end
