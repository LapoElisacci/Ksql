# frozen_string_literal: true

module Ksql
  module Query
    class Checker
      #
      # Even though ksqlDB actually allows you to perform SELECT Queries to the /ksql endpoint
      # The relative response must be handled differently
      # Therefore We need to ensure that the "query" method gets used instead.
      #
      # @param [String] sql Statement String
      #
      def self.call(sql)
        raise Ksql::Error.new("The 'query' endpoint only accepts SELECT statements, use 'ksql' instead.") unless sql.match?(/SELECT/i)
      end
    end
  end
end
