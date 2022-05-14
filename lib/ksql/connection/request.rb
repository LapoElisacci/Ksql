# frozen_string_literal: true

module Ksql
  module Connection
    class Request < Struct.new(:body, :endpoint, :headers, :method)
      #
      # Returns the request params
      #
      # @return [Array] Request params
      #
      def to_params
        return method, endpoint, { body: body.to_json, headers: headers.merge(auth_headers) }.compact
      end

      private

        #
        # Prepares Authorization headers if Auth is configured
        #
        # @return [Hash] Authorization headers
        #
        def auth_headers
          ::Ksql.config.auth.present? ? { 'Authorization' => "Basic #{::Ksql.config.auth}" } : {}
        end
    end
  end
end
