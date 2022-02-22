# frozen_string_literal: true

module Ksql
  module Api
    class CloseQuery < Base
      ENDPOINT = '/close-query'.freeze

      #
      # Perform a Sync request to /close-query endpoint
      #
      # @param [String] id Query ID
      # @param [Hash] headers Additional HTTP2 Request Headers
      #
      # @return [Ksql::Response] Request response
      #
      def call(id, headers: {})
        super(
          body: {
            queryId: id
          },
          headers: headers
        )
      end
    end
  end
end
