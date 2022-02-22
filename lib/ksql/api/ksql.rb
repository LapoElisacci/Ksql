# frozen_string_literal: true

module Ksql
  module Api
    class Ksql < Base
      ENDPOINT = '/ksql'.freeze

      #
      # Perform a Sync request to /ksql endpoint
      #
      # @param [String] ksql SQL String
      # @param [Integer] command_sequence_number If specified, the statements will not be run until all existing commands up to and including the specified sequence number have completed
      # @param [Hash] headers Additional HTTP2 Request Headers
      # @param [Hash] session_variables Variable substitution values
      # @param [Hash] streams_properties Property overrides to run the statements with.
      #
      # @return [Ksql::Response] Request response
      #
      def call(ksql, command_sequence_number: nil, headers: {}, session_variables: {}, streams_properties: {})
        super(
          body: {
            ksql: ksql,
            commandSequenceNumber: command_sequence_number,
            sessionVariables: session_variables,
            streamsProperties: streams_properties,
          }.compact,
          headers: headers
        )
      end
    end
  end
end
