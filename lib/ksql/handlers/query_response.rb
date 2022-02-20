# frozen_string_literal: true

module Ksql
  module Handlers
    class QueryResponse
      class << self
        #
        # <Description>
        #
        # @param [ClassName] struct <description>
        # @param [HTTParty::ResponseFragment] response <description>
        #
        # @return [Array(StructName, Struct)] <description>
        #
        def call(struct: nil, response:)
          result = nil

          unless struct.present?
            struct = evaluate_struct_from_headers(response)
          else
            # The response is a JSON string, the evalutation produces a Hash
            row_response = eval response
            # The Hash will fit inside our Struct
            result = struct.new(*row_response[:row][:columns])
          end

          # We return both the Struct Class and the Struct Instance
          return struct, result
        end

        private

          #
          # Evaluate the ksqlDB Header fragment to build a Struct class that will contain our data.
          #
          # @param [HTTParty::ResponseFragment] response The Query response fragment
          #
          # @return [struct Ksql::Class] Struct ClassName
          #
          def evaluate_struct_from_headers(response)
            # The header fragment contains an open square brackets that has to be removed
            response.slice!(0)
            # The response is now a JSON String, the evalutation produces a Hash
            header_response = eval response
            # Retrieve our Struct schema parsing the Header Hash
            instance_attributes = header_response[:header][:schema].split(',').map { |t| t.split(' ').first.tr('`', '').downcase.to_sym }
            # Define the Struct class with the parsed schema attributes
            Ksql.const_set(header_response[:header][:queryId].camelize, Class.new(Struct.new(*instance_attributes)))
          end
      end
    end
  end
end
