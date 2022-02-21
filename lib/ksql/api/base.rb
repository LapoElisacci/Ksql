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

      def prepare_request(body:)
        @client.prepare_request(
          :post,
          self.class::ENDPOINT,
          headers: { 'accept' => 'application/vnd.ksqlapi.delimited.v1' },
          body: body.to_json
        )
      end
    end
  end
end
