# frozen_string_literal: true

require 'json'
require 'net-http2'

module Ksql
  module Api
    class Base
      attr_reader :client

      def initialize
        @client = NetHttp2::Client.new(::Ksql.config.host)
      end

      #
      # Perform a NetHttp2 sync request
      #
      # @param [Hash] body HTTP Body
      # @param [Hash] headers HTTP Headers
      #
      # @return [Ksql::Response] Response instance
      #
      def call(body:, headers: { 'accept' => 'application/json' })
        response = @client.call(
          :post,
          self.class::ENDPOINT,
          body: body.to_json,
          headers: headers
        )

        ::Ksql::Response.new(response)
      ensure
        @client.close
      end

      #
      # Prepare a NetHttp2 async request
      #
      # @param [Hash] body HTTP Body
      # @param [Hash] headers HTTP Headers
      #
      # @return [NetHttp2::Request] Async prepared request
      #
      def prepare_request(body:, headers: { 'accept' => 'application/vnd.ksqlapi.delimited.v1' })
        @client.prepare_request(
          :post,
          self.class::ENDPOINT,
          headers: headers,
          body: body.to_json
        )
      end
    end
  end
end
