# frozen_string_literal: true

RSpec.describe Ksql::Api::HealthCheck do
  it 'Builds the ksqlDB /healthcheck request' do
    res = described_class.build(headers: { 'Accept' => 'application/json' })
    expect(res.class).to eq(Ksql::Connection::Request)
    expect(res.body).to eq({})
    expect(res.path).to eq('/healthcheck')
    expect(res.headers).to eq({ 'Accept' => 'application/json' })
    expect(res.method).to eq(:get)
  end
end
