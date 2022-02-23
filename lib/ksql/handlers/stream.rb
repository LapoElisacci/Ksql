# frozen_string_literal: true

module Ksql
  module Handlers
    class Stream
      #
      # Instanciate a Ksql::Stream class to handle the streamed connection
      #
      # @param [Ksql::Connection::Client] client Client instance
      # @param [Ksql::Connection::Request] request Built request
      #
      # @return [Ksql::Stream] Stream instance
      #
      def self.handle(client, request)
        ::Ksql::Stream.new(client, request)
      end
    end
  end
end
