# frozen_string_literal: true

RSpec.describe Ksql do
  it 'Has a version number' do
    expect(Ksql::VERSION).not_to be nil
  end

  it 'Allows to configure the connection' do
    res = described_class.configure do |config|
      config.host = 'http://localhost:8088'
      config.auth = 'user:password'
    end

    expect(res).to eq(true)
    expect(described_class.config.class).to eq(Ksql::Configuration)
    expect(described_class.config.host).to eq('http://localhost:8088')
    expect(described_class.config.auth).to eq('user:password')
  end
end
