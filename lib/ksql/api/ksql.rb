# frozen_string_literal: true

module Ksql
  module Api
    class Ksql < Base
      ENDPOINT = '/ksql'.freeze

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
