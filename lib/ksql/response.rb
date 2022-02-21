# frozen_string_literal: true

module Ksql
  class Response
    attr_reader :headers, :body

    def initialize(response)
      @headers = response.headers
      @body = JSON.parse(response.body)
    end

    #
    # Check whether or not a Request has returned an Error
    #
    # @return [Boolean] True if error
    #
    def error?
      !@headers[':status'].match?(/20[01]/)
    end
  end
end
