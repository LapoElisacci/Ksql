# frozen_string_literal: true

module Ksql
  module Api
    class CloseQuery < Base
      ENDPOINT = '/close-query'.freeze

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
