## <img src="https://user-images.githubusercontent.com/50866745/156314925-b823bfe2-a9d4-4b83-8376-29a6a659b57f.png" width="48"> ksqlDB Client  <!-- omit in toc -->
![](https://img.shields.io/static/v1?label=Language&message=Ruby&color=red)
![](https://img.shields.io/static/v1?label=Latest&message=0.1.0.beta.1&color=blue)

KSQL is a [ksqlDB](https://ksqldb.io/) Ruby client that focuses on ease of use. Supports all recent ksqlDB features and does not have any heavyweight dependencies.

## What is ksqlDB?  <!-- omit in toc -->

ksqlDB is a database purpose-built for [Apache Kafka®](https://kafka.apache.org/) streams processing applications, more details [here](https://ksqldb.io/).

**Official KLIP:**  <!-- omit in toc -->

- https://github.com/confluentinc/ksql/pull/8794
- https://github.com/confluentinc/ksql/pull/8865 

## Installation  <!-- omit in toc -->

Add this line to your application's Gemfile:

```ruby
gem 'ksql'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ksql

## Usage  <!-- omit in toc -->

The gem allows you to perform requests to ksqlDB REST API.
Checkout the ksqlDB official documentation [here](https://docs.ksqldb.io/en/latest/developer-guide/api/).

## Table of contents <!-- omit in toc -->

- [Configuration](#configuration)
- [Statements](#statements)
- [Queries](#queries)
  - [Persistent Query](#persistent-query)
  - [Push Query](#push-query)
  - [Pull Query](#pull-query)
- [Cluster Status](#cluster-status)
- [Health Check](#health-check)
- [Info](#info)
- [Terminate](#terminate)
- [Example](#example)
- [Supported ksqlDB versions](#supported-ksqldb-versions)
- [Known issues](#known-issues)
  - [ksqlDB close-query](#ksqldb-close-query)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)

## Configuration

The gem requires a minimum configuration to connect to ksqlDB, it is shipped with a built-in generator to create a Rails initializer.


    $ rails generate ksql
    
```Ruby
Ksql.configure do |config|
  config.host = 'http://localhost:8088' # Required
end
```

## [Statements](https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-rest-api/ksql-endpoint/)

All statements, except those starting with `SELECT` can be run with the `ksql` method:

```Ruby
Ksql::Client.ksql("SHOW TABLES;")

# Or

Ksql::Client.ksql("INSERT INTO riderLocations (profileId, latitude, longitude) VALUES ('18f4ea86', 37.3903, -122.0643);")
```

You can also pass optional `properties` to the method (Check the official documentation if needed).

```Ruby
Ksql::Client.ksql("INSERT INTO ...", command_sequence_number: 42, streams_properties: { ... }, session_variables: { ... })
```

As well as custom `Headers`.

```Ruby
Ksql::Client.ksql("INSERT INTO ...", headers: { ... })
```

## [Queries](https://docs.ksqldb.io/en/latest/concepts/queries)

ksqlDB has three kinds of Queries:

### [Persistent Query](https://docs.ksqldb.io/en/latest/concepts/queries/#persistent)

`Persistent queries` are server-side queries and there's nothing much to say here.

In case you want to close a `Persistent` Query you can do so with the `close_query` method, passing the Query ID:

```Ruby
Ksql::Client.close_query("CTAS_RIDERSNEARMOUNTAINVIEW_5")
```

**WARNING:** There's a known issue here, read [below](#ksqldb-close-query).

### [Push Query](https://docs.ksqldb.io/en/latest/concepts/queries/#push)

`Push` queries enable you to query a stream or materialized table with a subscription to the results. 
They run asynchronously and you can spot them as they include the `EMIT` keyword at the end of the SQL statement.

To define a `Push` query connection simply call the `stream` method:

```Ruby
stream = Ksql::Client.stream("SELECT * FROM riderLocations EMIT CHANGES;")
```

You can specify what action to take when an exception gets raised:

```Ruby
stream.on_error do |e|
  puts e.message
end
```

or what to do when the connection gets closed:

```Ruby
stream.on_close do
  puts 'Session closed!'
end
```

To start the stream, call the `start` method, It accepts a block to execute each time a message gets recieved:

```Ruby
stream.start do |location|
  # The streaming events get wrapped inside an ORM-like Class
  puts location.latitude
  puts location.longitude
end
```

**CAREFUL:** The block gets executed inside a separated Thread, make sure your code is thread safe!

You can close the connection by calling the `close` method:

```Ruby
stream.close
```

Example:

```Ruby
# Define the Stream
stream = Ksql::Client.stream("SELECT * FROM riderLocations EMIT CHANGES;")

# Start the connection
stream.start do |location|
  # This code will get executed inside a separated Thread
  puts location.latitude
  puts location.longitude
end

# Do something
sleep(10)

# Close the connection
stream.close
```

You can also specify custom `Properties` as well as `Headers` and `Session Variables`:

```Ruby
stream = Ksql::Client.stream("SELECT * FROM riderLocations EMIT CHANGES;", headers: { ... }, properties: { ... }, session_variables: { ... })
# ...
```

### [Pull Query](https://docs.ksqldb.io/en/latest/concepts/queries/#push)

`Pull` queries are the most "traditional" ones, they run synchronously and they can be executed with the `query` method"

```Ruby
locations = Ksql::Client.query("SELECT * FROM riderLocations;")
```

An Enumerable collection of ORM-like Objects is returned.
Iteration methods are available on the collection:

```Ruby
locations.each do |location|
  # do something
end

locations.map do |location|
  # do something
end

locations.count
```

## [Cluster Status](https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-rest-api/cluster-status-endpoint/)

The client allows you to introspect the cluster status with the `cluster_status` method.

**Careful:** The `/clusterStatus` endpoint is not enabled by default, read more [here](https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-rest-api/cluster-status-endpoint/)

```Ruby
  Ksql::Client.cluster_status
```

## [Health Check](https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-rest-api/info-endpoint/)

You can also check the health of your ksqlDB server by calling the `health_check` method.

```Ruby
  Ksql::Client.health_check
```

## [Info](https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-rest-api/info-endpoint/)

To get information about the status of a ksqlDB Server call the `info` method.

```Ruby
  Ksql::Client.info
```

## [Terminate](https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-rest-api/terminate-endpoint/)

You can terminate the cluster and clean up the resources calling the `terminate` method.

```Ruby
  Ksql::Client.terminate
```

You can provide a list of kafka topic names or regular expressions for Kafka topic names along to delete all topics with names that are in the list or that match any of the regular expressions in the list.

```Ruby
  Ksql::Client.terminate(delete_topic_list: ["FOO", "bar.*"])
```

## Example

The following example is from the official ksqlDB [Quickstart](https://ksqldb.io/quickstart.html):

```Ruby
require 'ksql'
require 'logger'

logger = Logger.new(STDOUT)
logger.level = Logger::INFO

# Create a stream

Ksql::Client.ksql("CREATE STREAM riderLocations (profileId VARCHAR, latitude DOUBLE, longitude DOUBLE)
  WITH (kafka_topic='locations', value_format='json', partitions=1);")

# Create materialized views

Ksql::Client.ksql("CREATE TABLE currentLocation AS
  SELECT profileId,
         LATEST_BY_OFFSET(latitude) AS la,
         LATEST_BY_OFFSET(longitude) AS lo
  FROM riderlocations
  GROUP BY profileId
  EMIT CHANGES;")

# Create materialized views

Ksql::Client.ksql("CREATE TABLE ridersNearMountainView AS
  SELECT ROUND(GEO_DISTANCE(la, lo, 37.4133, -122.1162), -1) AS distanceInMiles,
         COLLECT_LIST(profileId) AS riders,
         COUNT(*) AS count
  FROM currentLocation
  GROUP BY ROUND(GEO_DISTANCE(la, lo, 37.4133, -122.1162), -1);")

# Run a push query over the stream

stream = Ksql::Client.stream("SELECT * FROM riderLocations
  WHERE GEO_DISTANCE(latitude, longitude, 37.4133, -122.1162) <= 5 EMIT CHANGES;")

# Handle exceptions

stream.on_error do |e|
  logger.error(e.message)
end

# Handle stream close

stream.on_close do
  logger.info("Stream closed!")
end

# Start the stream

stream.start do |location|
  # Print the result into a file
  File.open('output.log', 'a') do |f|
    f.puts "Latitude: #{location.latitude}, Longitude: #{location.longitude}"
  end
end

# Populate the stream with events

Ksql::Client.ksql("INSERT INTO riderLocations (profileId, latitude, longitude)
  VALUES ('c2309eec', 37.7877, -122.4205);")
Ksql::Client.ksql("INSERT INTO riderLocations (profileId, latitude, longitude)
  VALUES ('18f4ea86', 37.3903, -122.0643);")
Ksql::Client.ksql("INSERT INTO riderLocations (profileId, latitude, longitude)
  VALUES ('4ab5cbad', 37.3952, -122.0813);")
Ksql::Client.ksql("INSERT INTO riderLocations (profileId, latitude, longitude)
  VALUES ('8b6eae59', 37.3944, -122.0813);")
Ksql::Client.ksql("INSERT INTO riderLocations (profileId, latitude, longitude)
  VALUES ('4a7c7b41', 37.4049, -122.0822);")
Ksql::Client.ksql("INSERT INTO riderLocations (profileId, latitude, longitude)
  VALUES ('4ddad000', 37.7857, -122.4011);")

# Run a Pull query against the materialized view

locations = Ksql::Client.query("SELECT * from ridersNearMountainView
  WHERE distanceInMiles <= 10;")

# Close the stream

stream.close

# Drop

Ksql::Client.ksql('DROP TABLE IF EXISTS ridersNearMountainView;')
Ksql::Client.ksql('DROP TABLE IF EXISTS currentLocation;')
Ksql::Client.ksql('DROP STREAM IF EXISTS riderLocations;')

```


## Supported ksqlDB versions

| Version |  |
| ------ | -- |
| 0.23.1 | :heavy_check_mark: Supported |
| 0.22.0 | :heavy_check_mark: Supported |
| Older | :x: Untested |

## Known issues

### ksqlDB close-query

Although it actually works, at the moment, the latest release of ksqlDB returns an error each time you request the `/close-query` endpoint.
Therefore the query will correctly get closed but an error will get returned anyways.

Official issue [here](https://github.com/confluentinc/ksql/issues/8251).

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rspec spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Make sure you have a working instance of ksqlDB, you can find the official quickstart [here](https://ksqldb.io/quickstart.html).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/LapoElisacci/ksql.

## License

[![Licence](https://img.shields.io/github/license/Ileriayo/markdown-badges?style=for-the-badge)](https://opensource.org/licenses/MIT)
