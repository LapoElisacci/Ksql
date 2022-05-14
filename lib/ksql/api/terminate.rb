# frozen_string_literal: true

module Ksql
  module Api
    class Terminate
      Headers = { 'Accept' => 'application/json' }.freeze

      #
      # Build the ksqlDB /ksql/terminate request
      #
      # @param [Array<String>] delete_topic_list Kafka topic names or regular expressions
      # @param [Hash] headers Request headers
      #
      # @return [Ksql::Connection::Request] Request instance
      #
      def self.build(delete_topic_list = null, headers:)
        ::Ksql::Connection::Request.new(
          { deleteTopicList: delete_topic_list }.compact,
          '/ksql/terminate',
          Headers.merge(headers),
          :post
        )
      end
    end
  end
end
