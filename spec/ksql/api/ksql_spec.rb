# frozen_string_literal: true

RSpec.describe Ksql::Api::Ksql do
  it 'Builds the ksqlDB /ksql request' do
    res = described_class.build('SELECT * FROM foo', command_sequence_number: 42, headers: { 'Accept' => 'application/json' }, session_variables: { foo: 'bar' }, streams_properties: { bar: 'foo' })
    expect(res.class).to eq(Ksql::Connection::Request)
    expect(res.body).to eq({ 'ksql': 'SELECT * FROM foo', 'commandSequenceNumber': 42, 'sessionVariables': { 'foo': 'bar' }, 'streamsProperties': { 'bar': 'foo' } })
    expect(res.path).to eq('/ksql')
    expect(res.headers).to eq({ 'Accept' => 'application/json' })
    expect(res.method).to eq(:post)
  end
end
