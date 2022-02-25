# frozen_string_literal: true

RSpec.describe Ksql::Handlers::Raw do
  context 'When response is not error' do
    let(:response) { Ksql::Connection::Response.new(body: [8888, 129.41, 49].to_json, headers: { ':status' => 200 }) }

    it 'Parses the JSON body and returns' do
      expect(response.error?).to eq(false)
      result = described_class.handle(response)
      expect(result).to eq([8888, 129.41, 49])
    end
  end
  context 'When response is error' do
    let(:response) { Ksql::Connection::Response.new(body: { error_code: 40001, message: 'Generic Error' }.to_json, headers: { ':status' => 400 }) }

    it 'Returns an error' do
      expect(response.error?).to eq(true)
      result = described_class.handle(response)
      expect(result.class).to eq(Ksql::Error)
      expect(result.message).to eq(response.body['message'])
      expect(result.error_code).to eq(response.body['error_code'])
    end
  end
end
