# frozen_string_literal: true

module Ksql
  module Handlers
    class TypedRow
      #
      # Define and instanciate an OpenStruct to fit the typed request response
      #
      # @param [Ksql::Connection::Response] response HTTP2 Request response
      #
      # @return [Ksql::@type] OpenStruct instance
      #
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
