# frozen_string_literal: true

require 'ksql'

# The following example is from https://ksqldb.io/quickstart.html

# * Create a stream

Ksql::Client.statement("CREATE STREAM riderLocations (profileId VARCHAR, latitude DOUBLE, longitude DOUBLE)
  WITH (kafka_topic='locations', value_format='json', partitions=1);")

# * Create materialized views

Ksql::Client.statement("CREATE TABLE currentLocation AS
  SELECT profileId,
         LATEST_BY_OFFSET(latitude) AS la,
         LATEST_BY_OFFSET(longitude) AS lo
  FROM riderlocations
  GROUP BY profileId
  EMIT CHANGES;")

Ksql::Client.statement("CREATE TABLE ridersNearMountainView AS
  SELECT ROUND(GEO_DISTANCE(la, lo, 37.4133, -122.1162), -1) AS distanceInMiles,
         COLLECT_LIST(profileId) AS riders,
         COUNT(*) AS count
  FROM currentLocation
  GROUP BY ROUND(GEO_DISTANCE(la, lo, 37.4133, -122.1162), -1);")

# * Run a push query over the stream

stream = Ksql::Client.query_stream("SELECT * FROM riderLocations
  WHERE GEO_DISTANCE(latitude, longitude, 37.4133, -122.1162) <= 5 EMIT CHANGES;")

stream.start do |location, _stream|
  # do something
  puts location.latitude
  puts location.longitude

  # You can also close the stream inside the block if you need to:

  stream.close
end

sleep(60)

stream.close

# * Populate the stream with events

Ksql::Client.statement("INSERT INTO riderLocations (profileId, latitude, longitude) VALUES ('c2309eec', 37.7877, -122.4205);")
Ksql::Client.statement("INSERT INTO riderLocations (profileId, latitude, longitude) VALUES ('18f4ea86', 37.3903, -122.0643);")
Ksql::Client.statement("INSERT INTO riderLocations (profileId, latitude, longitude) VALUES ('4ab5cbad', 37.3952, -122.0813);")
Ksql::Client.statement("INSERT INTO riderLocations (profileId, latitude, longitude) VALUES ('8b6eae59', 37.3944, -122.0813);")
Ksql::Client.statement("INSERT INTO riderLocations (profileId, latitude, longitude) VALUES ('4a7c7b41', 37.4049, -122.0822);")
Ksql::Client.statement("INSERT INTO riderLocations (profileId, latitude, longitude) VALUES ('4ddad000', 37.7857, -122.4011);")

# * Run a Pull query against the materialized view

Ksql::Client.query("SELECT * from ridersNearMountainView
  WHERE distanceInMiles <= 10;")