# frozen_string_literal: true

module Ksql
  module Api
    class QueryStream < Base
      ENDPOINT = '/query-stream'.freeze

      def call(sql, properties: {})
        super(
          body: {
            sql: sql,
            properties: properties
          }.compact
        )
      end

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
