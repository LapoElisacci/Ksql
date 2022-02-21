# frozen_string_literal: true

module Ksql
  class Client
    class << self
      #
      # Execute a close-query request on ksqlDB
      #
      # @param [String] id Query ID
      #
      # @return [Ksql::Error] ksqlDB Error "On wrong context or worker"
      #
      def close_query(id)
        response = Ksql::Api::CloseQuery.new.call(id)
        return Ksql::Error.new(response.body) if response.error?

        # TODO ksqlDB /close-query always return an error "On wrong context or worker"
        response
      end

      #
      # Execute a statement on ksqlDB '/ksql' endpoint
      #
      # @param [String] ksql Query String
      # @param [Hash] options Request optional arguments
      # @option properties [Hash] :streamsProperties Property overrides to run the statements with
      # @option properties [Hash] :sessionVariables Variable substitution values
      # @option properties [Integer] :commandSequenceNumber The statements will not be run until all existing commands up to and including the specified sequence number have completed.
      #
      # @return [Ksql::OpenStruct] Statement result
      #
      def ksql(ksql, options: {})
        response = Ksql::Api::Ksql.new.call(ksql, **options)
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
      # @param [Hash] properties Query optional properties
      #
      # @return [Ksql::Collection] Query result collection
      #
      def query(sql, properties: {})
        response = Ksql::Api::QueryStream.new.call(sql, properties: properties)
        return Ksql::Error.new(response.body) if response.error?

        parsed_body = response.body
        headers = parsed_body.shift
        Ksql::Collection.new(headers, parsed_body)
      end

      def query_stream(sql, properties: {}, &block)
        api = Ksql::Api::QueryStream.new
        request = api.prepare_request(sql, properties: properties)

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
