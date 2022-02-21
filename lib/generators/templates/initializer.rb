# frozen_string_literal: true

Ksql.configure do |config|
  config.host = 'http://localhost:8088' # required
  # config.auth = 'user:password' # optional
end
