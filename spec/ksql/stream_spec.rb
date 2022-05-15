# frozen_string_literal: true

RSpec.describe Ksql::Stream do
  def with_example_queries(&block)
    Ksql::Client.ksql("CREATE STREAM riderLocations (profileId VARCHAR, latitude DOUBLE, longitude DOUBLE)
                            WITH (kafka_topic='locations', value_format='json', partitions=1);")
    Ksql::Client.ksql("CREATE TABLE currentLocation AS
                            SELECT profileId,
                                  LATEST_BY_OFFSET(latitude) AS la,
                                  LATEST_BY_OFFSET(longitude) AS lo
                            FROM riderlocations
                            GROUP BY profileId
                            EMIT CHANGES;")
    Ksql::Client.ksql("CREATE TABLE ridersNearMountainView AS
        SELECT ROUND(GEO_DISTANCE(la, lo, 37.4133, -122.1162), -1) AS distanceInMiles,
              COLLECT_LIST(profileId) AS riders,
              COUNT(*) AS count
        FROM currentLocation
        GROUP BY ROUND(GEO_DISTANCE(la, lo, 37.4133, -122.1162), -1);")

    yield

    Ksql::Client.ksql('DROP TABLE IF EXISTS ridersNearMountainView;')
    Ksql::Client.ksql('DROP TABLE IF EXISTS currentLocation;')
    Ksql::Client.ksql('DROP STREAM IF EXISTS riderLocations;')
  end

  after(:each) do
    list_queries = Ksql::Client.ksql('SHOW QUERIES;')
    push_query = list_queries.queries.find { |q| q['queryType'] == 'PUSH' }
    Ksql::Client.close_query(push_query['id']) if push_query.present?
  end

  context 'close' do
    context 'when the stream has not started' do
      it 'raises an error' do
        stream = Ksql::Client.stream('SELECT * FROM riderLocations WHERE GEO_DISTANCE(latitude, longitude, 37.4133, -122.1162) <= 5 EMIT CHANGES;')
        expect { stream.close }.to raise_error(Ksql::StreamError)
      end
    end

    context 'when the stream has started' do
      it 'closes the stream' do
        with_example_queries do
          stream = Ksql::Client.stream('SELECT * FROM riderLocations WHERE GEO_DISTANCE(latitude, longitude, 37.4133, -122.1162) <= 5 EMIT CHANGES;')
          stream.start
          sleep(3)
          expect { stream.close }.to_not raise_error
        end
      end
    end

    context 'when on close is specified' do
      it 'executes the block' do
        with_example_queries do
          stream = Ksql::Client.stream('SELECT * FROM riderLocations WHERE GEO_DISTANCE(latitude, longitude, 37.4133, -122.1162) <= 5 EMIT CHANGES;')
          stream.start
          sleep(3)
          stream.on_close { expect(true).to be_truthy }
          stream.close
        end
      end
    end
  end

  context 'start' do
    context 'when the stream raises an error' do
      context 'when on_error is specified' do
        it 'executes the block' do
          with_example_queries do
            stream = Ksql::Client.stream('SELECT * FROM riderLocations WHERE GEO_DISTANCE(latitude, longitude, 37.4133, -122.1162) <= 5 EMIT CHANGES;')
            stream.on_error { expect(true).to be_truthy }
            stream.start
            sleep(3)
            allow(stream.instance_variable_get(:@request)).to receive(:body_chunk).and_raise(Ksql::StreamError)
            Ksql::Client.ksql("INSERT INTO riderLocations (profileId, latitude, longitude) VALUES ('c2309eec', 37.7877, -122.4205);")
            stream.close
          end
        end
      end
    end
  end
end
