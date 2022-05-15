# frozen_string_literal: true

RSpec.describe Ksql::Handlers::Collection do
  context 'When response is not error' do
    it 'Parses the JSON body and returns' do
      response = Ksql::Connection::Response.new(body: [{ 'queryId': 'query-id', 'columnNames': [ 'foo', 'bar' ] }, ['foo', 'bar']].to_json, headers: { ':status' => 200 })
      expect(response.error?).to eq(false)
      result = described_class.handle(response)
      expect(result.class).to eq(Ksql::Collection)
      expect(result.rows.class).to eq(Array)
      expect(result.rows.first.class.to_s.include? 'Ksql::Query').to eq(true)
      expect(result.rows.first.foo).to eq('foo')
      expect(result.rows.first.bar).to eq('bar')
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
