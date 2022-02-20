# frozen_string_literal: true

require 'HTTParty'

module Ksql
  class Http
    include HTTParty

    basic_auth Ksql.config.auth if Ksql.config.auth
    base_uri Ksql.config.host
    format :plain
    # The standard serialization format is application/vnd.ksql.v1+json
    # Although we negotiate with application/json for compatibility.
    headers 'Accept' => 'application/vnd.ksql.v1+json; q=0.9, application/json; q=0.5'

    class << self
      #
      # Request the ksqlDB ksql endpoint
      #
      # @param [String] sql Statement string
      # @param [Hash] options Request optional parameters
      #
      # @return [OpenStruct] Response
      #
      def ksql(sql, **options)
        Ksql::Statement::Checker.call(sql)
        result = post('/ksql', body: { ksql: sql }.merge(options).compact.to_json)
        Ksql::Statement::Handler.call(result)
      rescue Errno::ECONNREFUSED => e
        Ksql::Error.new(e.message)
      end

      #
      # Request the ksqlDB query endpoint
      #
      # @param [String] sql Query string
      # @param [Hash] options Request optional parameters
      # @param [Block] &block Events iteration block
      #
      # @return [Array(Struct)] Response buffer
      #
      def query(sql, **options, &block)
        Ksql::Query::Checker.call(sql)
        buffer = Ksql::Query::Buffer.new(permanent: !sql.match?(/EMIT/i))
        # The ksqlDB response is a buffered JSON string
        # This means that each fragment may not be a valid JSON on its own.
        # To return a valid structure we need to skip some fragments and keep the useful ones only
        post('/query', body: { ksql: sql }.merge(options).compact.to_json) do |res|
          result = Ksql::Query::Handler.call(res, buffer: buffer)
          next unless result.present?
          yield(result) if block_given?
        end

        buffer.buffer
      rescue Errno::ECONNREFUSED => e
        Ksql::Error.new(e.message)
      end
    end
  end
end
