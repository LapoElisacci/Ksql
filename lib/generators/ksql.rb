# frozen_string_literal: true

require 'rails/generators'

# Creates the Ksql initializer file for Rails apps.
#
# @example Invokation from terminal
#   rails generate ksql
#
class KsqlGenerator < Rails::Generators::Base
  desc "Description:\n  This creates a Rails initializer for Ksql"

  source_root File.expand_path('templates', __dir__)

  desc 'Configures Ksql to connect to ksqlDB'
  def generate_layout
    template 'initializer.rb', 'config/initializers/ksql.rb'
  end
end
