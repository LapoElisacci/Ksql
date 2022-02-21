# frozen_string_literal: true

require 'hashie/mash'

module Ksql
  class StreamError < StandardError; end

  class Stream
    attr_reader :id

    def initialize(api, request)
      @client = api.client
      @id = nil
      @request = request
      @struct = nil
    end

    #
    # Close the Stream connection if opened
    #
    # @return [Hash] {}
    #
    def close
      raise Ksql::StreamError.new('Stream not running.') unless @id.present?

      @client.close
    end

    #
    # Start the Query Stream and execute the passed block
    #
    # TODO Handle errors
    #
    # @param [Block] &block Block to be executed on each event
    #
    # @return [NilClass] Nil
    #
    def start(&block)
      @headers = {}

      @request.on(:headers) do |head|
        @headers = head
      end

      @request.on(:body_chunk) do |chunk|
        next unless chunk.present?

        response = Ksql::Response.new(::Hashie::Mash.new(headers: @headers, body: chunk))

        if response.error?
          raise Ksql::StreamError.new(response.body['message'])
        elsif response.body.is_a? Hash
          prepare_struct(response.body)
          next
        else
          event = @klass.new(*response.body)
        end

        yield(event)
      end

      @client.call_async(@request)
    end

    private

      #
      # * Attatch the Stream query ID
      # * Define the Struct to fit the event data
      #
      # @param [Hash] schema Stream event struct schema
      #
      def prepare_struct(schema)
        @id = schema['queryId']
        row_const = "Stream#{schema['queryId'].gsub('-', '_')}Row"
        @klass = Ksql.const_defined?(row_const) ? "Ksql::#{row_const}".constantize : Ksql.const_set(row_const, Class.new(Struct.new(*schema['columnNames'].map { |c| c.downcase.to_sym })))
      end
  end
end
