# frozen_string_literal: true

RSpec.describe Ksql::Connection::Client do
  context 'call_sync' do
    context 'close_query' do
      let(:request) {
        Ksql::Connection::Request.new(
          { queryId: 'query-id' },
          '/close-query',
          {},
          :post
        )
      }

      it 'returns a response' do
        res = described_class.call_sync(request)
        expect(res.class).to eq(Ksql::Connection::Response)
      end
    end

    context 'cluster_status' do
      let(:request) {
        Ksql::Connection::Request.new(
          {},
          '/clusterStatus',
          {},
          :get
        )
      }

      it 'returns a response' do
        res = described_class.call_sync(request)
        expect(res.class).to eq(Ksql::Connection::Response)
      end
    end

    context 'health_check' do
      let(:request) {
        Ksql::Connection::Request.new(
          {},
          '/healthcheck',
          {},
          :get
        )
      }

      it 'returns a response' do
        res = described_class.call_sync(request)
        expect(res.class).to eq(Ksql::Connection::Response)
      end
    end

    context 'info' do
      let(:request) {
        Ksql::Connection::Request.new(
          {},
          '/info',
          {},
          :get
        )
      }

      it 'returns a response' do
        res = described_class.call_sync(request)
        expect(res.class).to eq(Ksql::Connection::Response)
      end
    end

    context 'ksql' do
      let(:request) {
        Ksql::Connection::Request.new(
          { 'ksql': "CREATE STREAM riderLocations (profileId VARCHAR, latitude DOUBLE, longitude DOUBLE)
                      WITH (kafka_topic='locations', value_format='json', partitions=1);",
            'commandSequenceNumber': 1,
            'sessionVariables': {},
            'streamsProperties': {} },
          '/ksql',
          {},
          :post
        )
      }

      it 'returns a response' do
        res = described_class.call_sync(request)
        expect(res.class).to eq(Ksql::Connection::Response)
      end
    end

    context 'query' do
      let(:request) {
        Ksql::Connection::Request.new(
          { 'sql': 'SELECT * FROM riderLocations', 'properties': {}, 'sessionVariables': {} },
          '/query-stream',
          {},
          :post
        )
      }

      it 'returns a response' do
        res = described_class.call_sync(request)
        expect(res.class).to eq(Ksql::Connection::Response)
      end
    end

    # context 'terminate' do
    #   let(:request) {
    #     Ksql::Connection::Request.new(
    #       { 'deleteTopicList': [] },
    #       '/ksql/terminate',
    #       {},
    #       :post
    #     )
    #   }

    #   it 'returns a response' do
    #     res = described_class.call_sync(request)
    #     expect(res.class).to eq(Ksql::Connection::Response)
    #   end
    # end
  end

  context 'call_async' do
    context 'stream' do
      it 'returns a client and a prepared request' do
        request = Ksql::Connection::Request.new(
          { 'sql': 'SELECT * FROM foo', 'properties': { 'bar': 'foo' }, 'sessionVariables': { 'foo': 'bar' } },
          '/query-stream',
          {},
          :post
        )
        client, prepared_request = described_class.call_async(request)
        expect(client.class).to eq(NetHttp2::Client)
        expect(prepared_request.class).to eq(NetHttp2::Request)
      end
    end
  end
end
