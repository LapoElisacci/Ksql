# frozen_string_literal: true

module Ksql
  module Api
    class QueryStream < Base
      ENDPOINT = '/query-stream'.freeze

      #
      # Perform a Sync request to /query-stream endpoint
      #
      # @param [String] ksql SQL String
      # @param [Hash] properties Query optional properties
      #
      # @return [Ksql::Response] Request response
      #
      def call(sql, properties: {})
        super(
          body: {
            sql: sql,
            properties: properties
          }.compact
        )
      end

      #
      # Prepare an Async request to /query-stream endpoint
      #
      # @param [String] ksql SQL String
      # @param [Hash] properties Query optional properties
      #
      # @return [NetHttp2::Request] Async prepared request
      #
      def prepare_request(sql, properties: {})
        super(
          body: {
            sql: sql,
            properties: properties
          }.compact
        )
      end
    end
  end
end
