# frozen_string_literal: true

RSpec.describe Ksql::Api::Terminate do
  it 'Builds the ksqlDB /ksql/terminate request' do
    res = described_class.build(['topic_foo', 'topic_bar'], headers: { 'Accept' => 'application/json' })
    expect(res.class).to eq(Ksql::Connection::Request)
    expect(res.body).to eq({ 'deleteTopicList': ['topic_foo', 'topic_bar'] })
    expect(res.path).to eq('/ksql/terminate')
    expect(res.headers).to eq({ 'Accept' => 'application/json' })
    expect(res.method).to eq(:post)
  end
end
