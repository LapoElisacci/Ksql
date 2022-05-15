# frozen_string_literal: true

module Ksql
  class ConfigurationError < StandardError; end

  #
  # Ksql configuration
  #
  class Configuration
    REQUIRED_ATTRS = %i[host].freeze
    OPTIONAL_ATTRS = %i[auth].freeze

    attr_accessor(*REQUIRED_ATTRS + OPTIONAL_ATTRS)

    #
    # Ensure required attributes are properly configured
    #
    # @return [Boolean] true
    #
    def validate
      REQUIRED_ATTRS.each do |attribute|
        value = instance_variable_get("@#{attribute}")
        raise ConfigurationError, "Ksql required #{attribute} missing!" if value.nil? || value.strip.empty?
      end

      true
    end
  end
end
