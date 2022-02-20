# frozen_string_literal: true

module Ksql
  module Statement
    class Checker
      #
      # Unlike the ksql endpoint, the query one only accepts SELECT statements
      # Prevent ksqlDB from returning an error by checking this condition first.
      #
      # @param [String] sql Statement String
      #
      def self.call(sql)
        raise Ksql::Error.new("SELECT statements are not allowed on the 'ksql' endpoint, use 'query' instead.") if sql.match?(/SELECT/i)
      end
    end
  end
end
