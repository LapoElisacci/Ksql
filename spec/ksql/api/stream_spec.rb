# frozen_string_literal: true

RSpec.describe Ksql::Api::Stream do
  it 'Builds the ksqlDB /query-stream request' do
    res = described_class.build('SELECT * FROM foo', headers: { 'Accept' => 'application/json' }, properties: { bar: 'foo' }, session_variables: { foo: 'bar' })
    expect(res.class).to eq(Ksql::Connection::Request)
    expect(res.body).to eq({ 'sql': 'SELECT * FROM foo', 'properties': { 'bar': 'foo' }, 'sessionVariables': { 'foo': 'bar' } })
    expect(res.path).to eq('/query-stream')
    expect(res.headers).to eq({ 'Accept' => 'application/json' })
    expect(res.method).to eq(:post)
  end
end
