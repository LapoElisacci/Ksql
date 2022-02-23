# frozen_string_literal: true

module Ksql
  class Client
    class << self
      def close_query(id, headers: {})
        request = Api::CloseQuery.build(id, headers: headers)
        result = Connection::Client.call_sync(request)
        Handlers::Raw.handle(result)
      end

      def ksql(ksql, command_sequence_number: nil, headers: {}, session_variables: {}, streams_properties: {})
        request = Api::Ksql.build(ksql, command_sequence_number: command_sequence_number, headers: headers, session_variables: session_variables, streams_properties: streams_properties)
        result = Connection::Client.call_sync(request)
        Handlers::TypedRow.handle(result)
      end

      def query(sql, headers: {}, properties: {}, session_variables: {})
        request = Api::Query.build(sql, headers: headers, properties: properties, session_variables: session_variables)
        result = Connection::Client.call_sync(request)
        Handlers::Collection.handle(result)
      end

      def stream(sql, headers: {}, properties: {}, session_variables: {})
        request = Api::Stream.build(sql, headers: headers, properties: properties, session_variables: session_variables)
        client, prepared_request = Connection::Client.call_async(request)
        Handlers::Stream.handle(client, prepared_request)
      end
    end
  end
end
