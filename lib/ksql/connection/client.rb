# frozen_string_literal: true

require 'net-http2'

module Ksql
  module Connection
    class Client
      class << self
        #
        # Execute the HTTP2 Sync Request
        #
        # @param [Ksql::Connection::Request] request Built request
        #
        # @return [Ksql::Connection::Response] HTTP2 Request response
        #
        def call_sync(request)
          response = client.call(*request.to_params)
          ::Ksql::Connection::Response.new(body: response.body, headers: response.headers)
        end

        #
        # Prepare the HTTP2 Async Request based on the built input request
        #
        # @param [Ksql::Connection::Request] request Built request
        #
        # @return [Array] Client, Built Async Request
        #
        def call_async(request)
          @@client = client
          prepared_request = @@client.prepare_request(*request.to_params)
          return @@client, prepared_request
        end

        private

          #
          # Return HTTP2 Client instance
          #
          # @return [NetHttp2::Client] HTTP2 Client
          #
          def client
            NetHttp2::Client.new(::Ksql.config.host)
          end
      end
    end
  end
end
