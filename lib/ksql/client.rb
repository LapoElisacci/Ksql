# frozen_string_literal: true

module Ksql
  class Client
    class << self
      #
      # Execute a close-query request on ksqlDB
      #
      # @param [String] id Query ID
      # @param [Hash] headers Additional HTTP2 Request Headers
      #
      # @return [Ksql::Error] ksqlDB Error "On wrong context or worker"
      #
      def close_query(id, headers: {})
        response = Ksql::Api::CloseQuery.new.call(id, headers: headers)
        return Ksql::Error.new(response.body) if response.error?

        # TODO ksqlDB /close-query always return an error "On wrong context or worker"
        response
      end

      #
      # Execute a statement on ksqlDB '/ksql' endpoint
      #
      # @param [String] ksql Query Statement String
      # @param [Integer] command_sequence_number If specified, the statements will not be run until all existing commands up to and including the specified sequence number have completed
      # @param [Hash] headers Additional HTTP2 Request Headers
      # @param [Hash] session_variables Variable substitution values
      # @param [Hash] streams_properties Property overrides to run the statements with.
      #
      # @return [Ksql::OpenStruct] Statement result
      #
      def ksql(ksql, command_sequence_number: nil, headers: {}, session_variables: {}, streams_properties: {})
        response = Ksql::Api::Ksql.new.call(ksql, command_sequence_number: command_sequence_number, headers: headers, session_variables: session_variables, streams_properties: streams_properties)
        return Ksql::Error.new(response.body) if response.error?
        return response.body unless response.body.present?

        parsed_body = response.body.first
        row_type = parsed_body.delete('@type').camelize
        row_class = Ksql.const_defined?(row_type) ? "Ksql::#{row_type}".constantize : Ksql.const_set(row_type, Class.new(OpenStruct))
        row_class.new(parsed_body)
      end

      #
      # Execute a query on ksqlDB '/query-stream' endpoint
      #
      # @param [String] sql Query String
      # @param [Hash] headers Additional HTTP2 Request Headers
      # @param [Hash] properties Query optional properties
      #
      # @return [Ksql::Collection] Query result collection
      #
      def query(sql, headers: {}, properties: {})
        response = Ksql::Api::QueryStream.new.call(sql, headers: headers, properties: properties)
        return Ksql::Error.new(response.body) if response.error?

        parsed_body = response.body
        headers = parsed_body.shift
        Ksql::Collection.new(headers, parsed_body)
      end

      #
      # Prepare a Stream query connection
      #
      # @param [String] sql SQL Query Statement
      # @param [Hash] headers Additional HTTP2 Request Headers
      # @param [Hash] properties Statement optional properties
      #
      # @return [Ksql::Stream] Prepared Stream Query
      #
      def query_stream(sql, headers: {}, properties: {})
        api = Ksql::Api::QueryStream.new
        request = api.prepare_request(sql, headers: headers, properties: properties)

        Ksql::Stream.new(api, request)
      end

      private

        #
        # Return the HTTP2 Client instance
        #
        # @return [Ksql::Connections::Http2] Client instance
        #
        def client
          Ksql::Connection::Http2.new
        end
    end
  end
end
