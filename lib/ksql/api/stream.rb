# frozen_string_literal: true

module Ksql
  module Api
    class Stream < Query
      Headers = { 'Accept' => 'application/vnd.ksqlapi.delimited.v1' }.freeze

      # Inherits from Ksql::Api::Query overriding the request Accept header
    end
  end
end
