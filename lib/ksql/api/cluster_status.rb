# frozen_string_literal: true

module Ksql
  module Api
    class ClusterStatus
      Headers = { 'Accept' => 'application/json' }.freeze

      #
      # Build the ksqlDB /clusterStatus request
      #
      # @param [Hash] headers Request headers
      #
      # @return [Ksql::Connection::Request] Request instance
      #
      def self.build(headers:)
        ::Ksql::Connection::Request.new(
          {},
          '/clusterStatus',
          Headers.merge(headers),
          :get
        )
      end
    end
  end
end
