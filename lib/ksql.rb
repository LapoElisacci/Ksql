# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/string'
require 'ostruct'
require_relative 'ksql/configuration'
require_relative 'ksql/query/buffer'
require_relative 'ksql/query/checker'
require_relative 'ksql/query/handler'
require_relative 'ksql/statement/handler'
require_relative 'ksql/statement/checker'
require_relative 'ksql/version'

module Ksql
  class Error < StandardError; end

  def self.config
    @config ||= Ksql::Configuration.new
  end

  def self.configure
    yield(config)

    require_relative 'ksql/http'
  end
end
