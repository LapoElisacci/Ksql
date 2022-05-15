# frozen_string_literal: true

RSpec.describe Ksql::Api::ClusterStatus do
  it 'Builds the ksqlDB /clusterStatus request' do
    res = described_class.build(headers: { 'Accept' => 'application/json' })
    expect(res.class).to eq(Ksql::Connection::Request)
    expect(res.body).to eq({})
    expect(res.path).to eq('/clusterStatus')
    expect(res.headers).to eq({ 'Accept' => 'application/json' })
    expect(res.method).to eq(:get)
  end
end
