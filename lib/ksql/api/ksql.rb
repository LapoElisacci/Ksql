# frozen_string_literal: true

module Ksql
  module Api
    class Ksql < Base
      ENDPOINT = '/ksql'.freeze

      #
      # Perform a Sync request to /ksql endpoint
      #
      # @param [String] ksql SQL String
      # @param [Hash] **options SQL Statement options
      #
      # @return [Ksql::Response] Request response
      #
      def call(ksql, **options)
        super(
          body: {
            ksql: ksql
          }.merge(options).compact
        )
      end
    end
  end
end
