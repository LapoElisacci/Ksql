# frozen_string_literal: true

RSpec.describe Ksql::Handlers::Stream do
  it 'returns a Ksql::Stream instance' do
    request = Ksql::Connection::Request.new(
      { 'sql': 'SELECT * FROM foo', 'properties': { 'bar': 'foo' }, 'sessionVariables': { 'foo': 'bar' } },
      '/query-stream',
      { 'Accept' => 'application/json' },
      :post
    )
    client, prepared_request = Ksql::Connection::Client.call_async(request)

    res = described_class.handle(client, prepared_request)
    expect(res.class).to eq(Ksql::Stream)
  end
end
