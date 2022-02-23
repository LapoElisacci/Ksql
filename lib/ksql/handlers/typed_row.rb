# frozen_string_literal: true

# TODO DOC

module Ksql
  module Handlers
    class TypedRow
      def self.handle(response)
        return Ksql::Error.new(response.body) if response.error?
        return response.body unless response.body.present?

        parsed_body = response.body.first
        row_type = parsed_body.delete('@type').camelize
        row_class = Ksql.const_defined?(row_type) ? "Ksql::#{row_type}".constantize : Ksql.const_set(row_type, Class.new(OpenStruct))
        row_class.new(parsed_body)
      end
    end
  end
end
