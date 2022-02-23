# frozen_string_literal: true

# TODO DOC

module Ksql
  class StreamError < StandardError; end

  class Stream
    attr_reader :event_class

    def initialize(client, request)
      @client = client
      @request = request
    end

    def close
      raise StreamError.new('Stream ID hasn\'t been assigned yet, the stream may not be open.') unless @id.present?

      @client.close
    end

    def on_close(&block)
      @client.on(:close) { |e| yield(e) }
    end

    def on_error(&block)
      @client.on(:error) { |e| yield(e) }
    end

    def start(&block)
      @headers = {}

      @request.on(:headers) { |headers| @headers = headers }

      @request.on(:body_chunk) do |body|
        next unless body.present?

        response = Ksql::Http::Response.new(body: body, headers: @headers)
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

      def build_event_class(event_schema)
        @id = event_schema['queryId']
        row_const = "Stream#{schema['queryId'].gsub('-', '_')}Row"
        Ksql.const_defined?(row_const) ? "Ksql::#{row_const}".constantize : Ksql.const_set(row_const, Class.new(Struct.new(*schema['columnNames'].map { |c| c.downcase.to_sym })))
      end
  end
end
