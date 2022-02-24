# frozen_string_literal: true

module Ksql
  module Api
    class Ksql
      Headers = { 'Accept' => 'application/json' }.freeze

      #
      # Build the ksqlDB /ksql request
      #
      # @param [String] ksql SQL Statement
      # @param [Integer] command_sequence_number The statements will not be run until all existing commands have completed.
      # @param [Hash] headers Request headers
      # @param [Hash] session_variables Variable substitution values
      # @param [Hash] streams_properties Property overrides to run the statements with
      #
      # @return [Ksql::Connection::Request] Request instance
      #
      def self.build(ksql, command_sequence_number:, headers:, session_variables:, streams_properties:)
        ::Ksql::Connection::Request.new(
          {
            ksql: ksql,
            commandSequenceNumber: command_sequence_number,
            sessionVariables: session_variables,
            streamsProperties: streams_properties,
          }.compact,
          '/ksql',
          Headers.merge(headers),
          :post
        )
      end
    end
  end
end
