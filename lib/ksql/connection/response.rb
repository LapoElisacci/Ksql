# frozen_string_literal: true

module Ksql
  module Connection
    class Response
      attr_reader :body, :headers

      STATUS_KEY = ':status'.freeze

      def initialize(body:, headers:)
        @body = JSON.parse(body)
        @headers = headers
      end

      #
      # Check whether or not a Request has returned an Error
      #
      # @return [Boolean] True if error
      #
      def error?
        !headers[STATUS_KEY].to_s.match?(/20[01]/)
      end
    end
  end
end
