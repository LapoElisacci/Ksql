# frozen_string_literal: true

RSpec.describe Ksql::Connection::Request do
  context 'to_params' do
    let(:request) { described_class.new({ ksql: 'WHATEVER' }, '/ksql', { 'Accept' => 'application/json' }, :post) }

    context 'When auth is not defined' do
      it 'Returns Request params as expected' do
        params = request.to_params
        expect(params.class).to eq(Array)
        expect(params[0]).to eq(:post)
        expect(params[1]).to eq('/ksql')
        expect(params[2].class).to eq(Hash)
        expect(params[2][:body]).to eq({ ksql: 'WHATEVER' }.to_json)
        expect(params[2][:headers]).to eq({ 'Accept' => 'application/json' })
      end
    end

    context 'When auth is defined' do
      it 'Returns Request params with Auth header as expected' do
        allow_any_instance_of(Ksql::Configuration).to receive(:auth).and_return('user:password')

        params = request.to_params

        expect(params.class).to eq(Array)
        expect(params[0]).to eq(:post)
        expect(params[1]).to eq('/ksql')
        expect(params[2].class).to eq(Hash)
        expect(params[2][:body]).to eq({ ksql: 'WHATEVER' }.to_json)
        expect(params[2][:headers]).to eq({ 'Accept' => 'application/json', 'Authorization' => 'Basic user:password' })
      end
    end
  end
end
