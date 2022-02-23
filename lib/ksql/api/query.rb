# frozen_string_literal: true

module Ksql
  module Api
    class Query
      Headers = { 'Accept' => 'application/json' }.freeze

      #
      # Build the ksqlDB /query-stream request
      #
      # @param [String] sql SQL Statement
      # @param [Hash] headers Request headers
      # @param [Hash] properties Optional properties for the query
      # @param [Hash] session_variables Variable substitution values
      #
      # @return [Ksql::Connection::Request] Request instance
      #
      def self.build(sql, headers:, properties:, session_variables:)
        ::Ksql::Connection::Request.new(
          {
            sql: sql,
            properties: properties,
            sessionVariables: session_variables
          }.compact,
          '/query-stream',
          self.class::Headers.merge(headers),
          :post
        )
      end
    end
  end
end
