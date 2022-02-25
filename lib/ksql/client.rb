# frozen_string_literal: true

module Ksql
  class Client
    class << self
      #
      # Request /close-query endpoint
      #
      # @param [String] id Query ID
      # @param [Hash] headers Request headers
      #
      # @return [Array/Hash/String/Integer] Request result
      #
      def close_query(id, headers: {})
        request = Api::CloseQuery.build(id, headers: headers)
        result = Connection::Client.call_sync(request)
        Handlers::Raw.handle(result)
      end

      #
      # Request /ksql endpoint
      #
      # @param [String] ksql SQL Statement
      # @param [Integer] command_sequence_number The statements will not be run until all existing commands have completed.
      # @param [Hash] headers Request headers
      # @param [Hash] session_variables Variable substitution values
      # @param [Hash] streams_properties Property overrides to run the statements with
      #
      # @return [Ksql::@type] Request result
      #
      def ksql(ksql, command_sequence_number: nil, headers: {}, session_variables: {}, streams_properties: {})
        request = Api::Ksql.build(ksql, command_sequence_number: command_sequence_number, headers: headers, session_variables: session_variables, streams_properties: streams_properties)
        result = Connection::Client.call_sync(request)
        Handlers::TypedList.handle(result)
      end

      #
      # Request /query-stream endpoint synchronously
      #
      # @param [String] sql SQL Statement
      # @param [Hash] headers Request headers
      # @param [Hash] properties Optional properties for the query
      # @param [Hash] session_variables Variable substitution values
      #
      # @return [Ksql::Connection::Request] Request result
      #
      def query(sql, headers: {}, properties: {}, session_variables: {})
        request = Api::Query.build(sql, headers: headers, properties: properties, session_variables: session_variables)
        result = Connection::Client.call_sync(request)
        Handlers::Collection.handle(result)
      end

      #
      # Request /query-stream endpoint asynchronously
      #
      # @param [String] sql SQL Statement
      # @param [Hash] headers Request headers
      # @param [Hash] properties Optional properties for the query
      # @param [Hash] session_variables Variable substitution values
      #
      # @return [Ksql::Stream] Stream instance
      #
      def stream(sql, headers: {}, properties: {}, session_variables: {})
        request = Api::Stream.build(sql, headers: headers, properties: properties, session_variables: session_variables)
        client, prepared_request = Connection::Client.call_async(request)
        Handlers::Stream.handle(client, prepared_request)
      end
    end
  end
end
