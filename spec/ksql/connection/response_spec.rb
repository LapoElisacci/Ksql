# frozen_string_literal: true

RSpec.describe Ksql::Connection::Response do
  context 'When the request returns an error' do
    let(:response) { described_class.new(body: { error_code: '40001', message: 'Something went wrong!' }.to_json, headers: { ':status' => '500' }) }

    it 'The body gets parsed' do
      expect(response.body.class).to eq(Hash)
      expect(response.body).to eq({ 'error_code' => '40001', 'message' => 'Something went wrong!' })
    end

    it 'error is true' do
      expect(response.error?).to eq(true)
    end
  end

  context 'When the request returns no error' do
    let(:response) { described_class.new(body: { status: 'ok', seq: 0 }.to_json, headers: { ':status' => '200' }) }

    it 'The body gets parsed' do
      expect(response.body.class).to eq(Hash)
      expect(response.body).to eq({ 'status' => 'ok', 'seq' => 0 })
    end

    it 'error is false' do
      expect(response.error?).to eq(false)
    end
  end
end
