# frozen_string_literal: true

RSpec.describe Ksql::Client do
  def with_example_queries(&block)
    described_class.ksql("CREATE STREAM riderLocations (profileId VARCHAR, latitude DOUBLE, longitude DOUBLE)
                            WITH (kafka_topic='locations', value_format='json', partitions=1);")
    described_class.ksql("CREATE TABLE currentLocation AS
                            SELECT profileId,
                                  LATEST_BY_OFFSET(latitude) AS la,
                                  LATEST_BY_OFFSET(longitude) AS lo
                            FROM riderlocations
                            GROUP BY profileId
                            EMIT CHANGES;")
    described_class.ksql("CREATE TABLE ridersNearMountainView AS
        SELECT ROUND(GEO_DISTANCE(la, lo, 37.4133, -122.1162), -1) AS distanceInMiles,
              COLLECT_LIST(profileId) AS riders,
              COUNT(*) AS count
        FROM currentLocation
        GROUP BY ROUND(GEO_DISTANCE(la, lo, 37.4133, -122.1162), -1);")

    yield

    described_class.ksql('DROP TABLE IF EXISTS ridersNearMountainView;')
    described_class.ksql('DROP TABLE IF EXISTS currentLocation;')
    described_class.ksql('DROP STREAM IF EXISTS riderLocations;')
  end

  context 'close_query' do
    context 'When the query exists' do
      it 'closes the query' do
        with_example_queries do
          stream = Ksql::Client.stream('SELECT * FROM riderLocations WHERE GEO_DISTANCE(latitude, longitude, 37.4133, -122.1162) <= 5 EMIT CHANGES;')
          stream.start do |location|
            puts location
          end
          sleep(3)

          list_queries = described_class.ksql('SHOW QUERIES;')
          expect(list_queries.queries.count).to eq(3)
          push_query = list_queries.queries.find { |q| q['queryType'] == 'PUSH' }
          res = described_class.close_query(push_query['id'])

          expect(res.class).to eq(Ksql::Error)
          expect(res.error_code).to eq(50_000)
          expect(res.message).to eq('On wrong context or worker')

          stream.close

          list_queries = described_class.ksql('SHOW QUERIES;')
          expect(list_queries.queries.count >= 2).to eq(true)
        end
      end
    end

    context 'When the query does not exist' do
      it 'Returns an error' do
        res = described_class.close_query('query-id')
        expect(res.class).to eq(Ksql::Error)
        expect(res.error_code).to eq(40000)
        expect(res.message).to eq('No query with id query-id')
      end
    end
  end

  context 'custer_status' do
    it 'returns cluster status' do
      res = described_class.cluster_status
      expect(res.class).to eq(Ksql::Connection::Response)
    end
  end

  context 'health_check' do
    it 'returns health check' do
      res = described_class.health_check
      expect(res.class).to eq(Ksql::Connection::Response)
    end
  end

  context 'info' do
    it 'returns info' do
      res = described_class.info
      expect(res.class).to eq(Ksql::Connection::Response)
    end
  end

  context 'ksql' do
    it 'returns Struct data' do
      res = described_class.ksql('SHOW TABLES;')
      expect(res.class).to eq(Ksql::Tables)
    end
  end

  context 'query' do
    it 'Query a stream' do
      with_example_queries do
        res = described_class.query('SELECT * FROM riderLocations WHERE GEO_DISTANCE(latitude, longitude, 37.4133, -122.1162) <= 5;')
        expect(res.class).to eq(Ksql::Collection)
      end
    end
  end

  context 'stream' do
    it 'returns a stream' do
      with_example_queries do
        res = described_class.stream('SELECT * FROM riderLocations WHERE GEO_DISTANCE(latitude, longitude, 37.4133, -122.1162) <= 5 EMIT CHANGES;')
        expect(res.class).to eq(Ksql::Stream)
      end
    end
  end
end
