# frozen_string_literal: true

RSpec.describe Ksql::Handlers::TypedList do
  context 'When response is not error' do
    it 'Parses the JSON body and returns' do
      response = Ksql::Connection::Response.new(body: [{ '@type': 'Foo', 'foo': 'bar', 'bar': 'foo' }].to_json, headers: { ':status' => 200 })
      expect(response.error?).to eq(false)
      result = described_class.handle(response)
      expect(result.class).to eq(Ksql::Foo)
      expect(result.foo).to eq('bar')
      expect(result.bar).to eq('foo')
    end
  end

  context 'When response is error' do
    it 'Parses the JSON body and returns' do
      response = Ksql::Connection::Response.new(body: { 'message': 'error' }.to_json, headers: { ':status' => 400 })
      expect(response.error?).to eq(true)
      result = described_class.handle(response)
      expect(result.class).to eq(Ksql::Error)
      expect(result.message).to eq('error')
    end
  end
end
