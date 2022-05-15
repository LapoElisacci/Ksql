# frozen_string_literal: true

RSpec.describe Ksql::Api::CloseQuery do
  it 'Builds the ksqlDB /close-query request' do
    res = described_class.build('query-id', headers: { 'Accept' => 'application/json' })
    expect(res.class).to eq(Ksql::Connection::Request)
    expect(res.body).to eq({ 'queryId': 'query-id' })
    expect(res.path).to eq('/close-query')
    expect(res.headers).to eq({ 'Accept' => 'application/json' })
    expect(res.method).to eq(:post)
  end
end
