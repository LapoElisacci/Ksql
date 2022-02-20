# frozen_string_literal: true

module Ksql
  module Statement
    class Handler
      def self.call(response)
        result = JSON.parse(response)

        # Any response apart from the errors one returns a list, apparentely with just a single element inside.
        result = result.first unless (result['error_core'].present? rescue false)

        row_type = result.delete('@type')
        row_class = Ksql.const_set(row_type.camelize, Class.new(OpenStruct))
        row_class.new(result)
      end
    end
  end
end
