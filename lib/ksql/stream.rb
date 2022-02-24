# frozen_string_literal: true

module Ksql
  class StreamError < StandardError; end

  class Stream
    attr_reader :id

    def initialize(client, request)
      @client = client
      @request = request
    end

    #
    # Close the streaming connection
    #
    def close
      raise StreamError.new('The stream hasn\'t stared!') unless @id.present?

      @client.close
    end

    #
    # Specify the action to take when the Streaming connection gets closed.
    #
    # @param [Block] &block Code to execute on connection closure
    #
    def on_close(&block)
      @client.on(:close) { |e| yield(e) }
    end

    #
    # Specify the action to take when the Streaming connection raises an error.
    #
    # @param [Block] &block Code to execute when connection errors occur
    #
    def on_error(&block)
      @client.on(:error) { |e| yield(e) }
    end

    #
    # Streaming connection handler
    #
    # * Start the stream
    # * Wrap the stream events into OpenStruct instances
    # * Execute the passed block
    #
    # @param [Block] &block Code to execute each time an event arrives
    #
    def start(&block)
      @headers = {}

      @request.on(:headers) { |headers| @headers = headers }

      @request.on(:body_chunk) do |body|
        next unless body.present?

        response = Ksql::Connection::Response.new(body: body, headers: @headers)
        raise Ksql::StreamError.new(response.body['message']) if response.error?

        if response.body.is_a? Hash
          @event_class = build_event_class(response.body)
          next
        else
          event = @event_class.new(*response.body)
        end

        yield(event)
      end

      @client.call_async(@request)
    end

    private

      #
      # Define a Struct class to fit the streaming data into.
      #
      # @param [Hash] schema Query schema
      #
      # @return [Ksql::Row] Stream event class
      #
      def build_event_class(schema)
        @id = schema['queryId']
        row_const = "Stream#{schema['queryId'].gsub('-', '_')}Row"
        Ksql.const_defined?(row_const) ? "Ksql::#{row_const}".constantize : Ksql.const_set(row_const, Class.new(Struct.new(*schema['columnNames'].map { |c| c.downcase.to_sym })))
      end
  end
end
