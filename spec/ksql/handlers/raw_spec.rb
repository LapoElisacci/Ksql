# frozen_string_literal: true

RSpec.describe Ksql::Handlers::Raw do
  context 'When response is not error' do
    it 'Parses the JSON body and returns' do
      response = Ksql::Connection::Response.new(body: [{ 'foo': 'bar' }].to_json, headers: { ':status' => 200 })
      expect(response.error?).to eq(false)
      result = described_class.handle(response)
      expect(result.class).to eq(Array)
      expect(result.first.class).to eq(Hash)
      expect(result.first['foo']).to eq('bar')
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
