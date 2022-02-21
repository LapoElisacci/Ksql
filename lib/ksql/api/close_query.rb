# frozen_string_literal: true

module Ksql
  module Api
    class CloseQuery < Base
      ENDPOINT = '/close-query'.freeze

      #
      # Perform a Sync request to /close-query endpoint
      #
      # @param [String] id Query ID
      #
      # @return [Ksql::Response] Request response
      #
      def call(id)
        super(
          body: {
            queryId: id
          }
        )
      end
    end
  end
end
