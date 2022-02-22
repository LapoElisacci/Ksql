# frozen_string_literal: true

module Ksql
  module Api
    class QueryStream < Base
      ENDPOINT = '/query-stream'.freeze

      #
      # Perform a Sync request to /query-stream endpoint
      #
      # @param [String] ksql SQL String
      # @param [Hash] headers Query optional properties
      # @param [Hash] properties Query optional properties
      #
      # @return [Ksql::Response] Request response
      #
      def call(sql, headers: {}, properties: {})
        super(
          body: {
            sql: sql,
            properties: properties
          }.compact,
          headers: headers
        )
      end

      #
      # Prepare an Async request to /query-stream endpoint
      #
      # @param [String] ksql SQL String
      # @param [Hash] headers Additional HTTP2 Request Headers
      # @param [Hash] properties Query optional properties
      #
      # @return [NetHttp2::Request] Async prepared request
      #
      def prepare_request(sql, headers: {}, properties: {})
        super(
          body: {
            sql: sql,
            properties: properties
          }.compact,
          headers: headers
        )
      end
    end
  end
end
