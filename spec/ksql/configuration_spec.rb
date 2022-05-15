# frozen_string_literal: true

RSpec.describe Ksql::Configuration do
  context 'When required attributes are configured' do
    it 'Configuration is valid' do
      configuration = described_class.new
      configuration.host = 'http://localhost:8088'
      configuration.auth = 'user:password'
      expect(configuration.validate).to eq(true)
      expect(configuration.host).to eq('http://localhost:8088')
      expect(configuration.auth).to eq('user:password')
    end
  end

  context 'When Configuration is not valid' do
    it 'Raises an exception' do
      configuration = described_class.new
      configuration.auth = 'user:password'
      expect { configuration.validate }.to raise_error(Ksql::ConfigurationError)
    end
  end
end
