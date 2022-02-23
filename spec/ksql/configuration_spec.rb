# frozen_string_literal: true

RSpec.describe Ksql::Configuration do
  it 'Allows the user to configure host and auth' do
    conf = described_class.new(host: 'http://localhost:8088', auth: 'user:password')
    expect(conf.host).to eq('http://localhost:8088')
    expect(conf.auth).to eq('user:password')
  end
end
