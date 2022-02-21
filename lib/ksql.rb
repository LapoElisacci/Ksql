# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/string'
require 'ostruct'

require_relative 'ksql/api/base'
require_relative 'ksql/api/close_query'
require_relative 'ksql/api/ksql'
require_relative 'ksql/api/query_stream'

require_relative 'ksql/configuration'
require_relative 'ksql/client'
require_relative 'ksql/collection'
require_relative 'ksql/error'
require_relative 'ksql/response'
require_relative 'ksql/stream'
require_relative 'ksql/version'

module Ksql
  def self.config
    @config ||= Ksql::Configuration.new
  end

  def self.configure
    yield(config)
  end
end
