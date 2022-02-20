# frozen_string_literal: true

module Ksql
  module Query
    class Handler
      class << self
        def call(response, buffer:)
          return if skip?(response)
          return handle_buffer_struct(buffer, response: response) unless buffer.struct.present?

          row_response = eval response
          buffer.struct_instance(row_response[:row][:columns])
        end

        private

          def handle_buffer_struct(buffer, response:)
            # The header fragment contains an open square brackets that has to be removed
            response.slice!(0)
            # The response is now a JSON String, the evalutation produces a Hash
            header_response = eval response
            # Retrieve our Struct schema parsing the Header Hash
            instance_attributes = header_response[:header][:schema].split(',').map { |t| t.split(' ').first.tr('`', '').downcase.to_sym }
            # Define the Struct class with the parsed schema attributes
            buffer.define_struct(header_response[:header][:queryId].camelize, attributes: instance_attributes)

            nil
          end

          def skip?(response)
            !response.present? || response.to_s.strip == ',' || response.to_s.strip == ']'
          end
      end
    end
  end
end
