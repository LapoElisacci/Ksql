# frozen_string_literal: true

module Ksql
  module Api
    class HealthCheck
      Headers = { 'Accept' => 'application/json' }.freeze

      #
      # Build the ksqlDB /healthcheck request
      #
      # @param [Hash] headers Request headers
      #
      # @return [Ksql::Connection::Request] Request instance
      #
      def self.build(headers:)
        ::Ksql::Connection::Request.new(
          {},
          '/healthcheck',
          Headers.merge(headers),
          :get
        )
      end
    end
  end
end
