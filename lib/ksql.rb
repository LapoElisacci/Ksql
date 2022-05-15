# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/string'
require 'json'
require 'ostruct'

require_relative 'ksql/api/close_query'
require_relative 'ksql/api/cluster_status'
require_relative 'ksql/api/health_check'
require_relative 'ksql/api/info'
require_relative 'ksql/api/ksql'
require_relative 'ksql/api/query'
require_relative 'ksql/api/stream'
require_relative 'ksql/api/terminate'

require_relative 'ksql/handlers/collection'
require_relative 'ksql/handlers/raw'
require_relative 'ksql/handlers/stream'
require_relative 'ksql/handlers/typed_list'

require_relative 'ksql/connection/client'
require_relative 'ksql/connection/request'
require_relative 'ksql/connection/response'

require_relative 'ksql/client'
require_relative 'ksql/collection'
require_relative 'ksql/configuration'
require_relative 'ksql/error'
require_relative 'ksql/stream'

require_relative 'ksql/version'

module Ksql
  class << self
    attr_accessor :config

    #
    # Configure Ksql
    #
    # @return [Boolean] true
    #
    def configure
      self.config = Ksql::Configuration.new
      yield(config)
      config.validate
    end
  end
end
