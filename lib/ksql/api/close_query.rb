# frozen_string_literal: true

module Ksql
  module Api
    class CloseQuery
      Headers = { 'Accept' => 'application/json' }.freeze

      #
      # Build the ksqlDB /close-query request
      #
      # @param [String] id Query ID
      # @param [Hash] headers Request headers
      #
      # @return [Ksql::Connection::Request] Request instance
      #
      def self.build(id, headers:)
        ::Ksql::Connection::Request.new(
          { queryId: id },
          '/close-query',
          Headers.merge(headers),
          :post
        )
      end
    end
  end
end
