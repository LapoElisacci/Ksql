![][ruby-shield]

<p align="center">
  <img width="180" src="https://user-images.githubusercontent.com/50866745/147449973-a743b690-fef4-4b97-86d3-cc01f1695118.png" >
</p>

# Ruby KSQL

![](https://img.shields.io/static/v1?label=Latest&message=0.1.0&color=blue)
![](https://img.shields.io/static/v1?label=Coverage&message=95%&color=green)
![](https://img.shields.io/static/v1?label=Documentation&message=98%&color=success)
![](https://img.shields.io/static/v1?label=Mantained?&message=Yes&color=success)
<!-- ![](https://img.shields.io/static/v1?label=Test&message=0%&color=red) -->

KSQL is a [ksqlDB](https://ksqldb.io/) Ruby client that focuses on ease of use. Supports all recent ksqlDB features and does not have any heavyweight dependencies.

## What is ksqlDB?

ksqlDB is a database purpose-built for [Apache Kafka®](https://kafka.apache.org/) streams processing applications, more details [here](https://ksqldb.io/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ksql'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ksql

## Usage

KSQL allows you to perform Queries / Statements requests to ksqlDB REST API. 

### Configuration

The gem requires a minimum configuration to connect to ksqlDB, it is shipped with a built-in generator to create a Rails initializer.


    $ rails generate ksql
    
```Ruby
Ksql.configure do |config|
  config.host = 'http://localhost:8088' # Required
end
```

### Statements

All statements, except those starting with `SELECT` ([ksqlDB API Documentation](https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-rest-api/ksql-endpoint/)), can be run with the `ksql` method:

```Ruby
Ksql::Client.ksql("SHOW TABLES;")

# Or

Ksql::Client.ksql("INSERT INTO riderLocations (profileId, latitude, longitude) VALUES ('18f4ea86', 37.3903, -122.0643);")
```

## Queries

ksqlDB has three kinds of Queries (more details [here](https://docs.ksqldb.io/en/latest/concepts/queries/)).

### Persisten Query

`Persistent queries` are server-side queries and there's nothing much to say here.

You can checkout the official doc [here](https://docs.ksqldb.io/en/latest/concepts/queries/#persistent)

### Push Query

`Push` queries enable you to query a stream or materialized table with a subscription to the results. 
They run asynchronously and you can spot them as they usually (should we say always?) include the `EMIT` keyword at the end of the SQL statement.

The gem allows you to create a `ksqlDB Push query` connection through the `query_stream` method:

```Ruby
stream = Ksql::Client.query_stream("SELECT * FROM riderLocations EMIT CHANGES;")
```

to subscribe the Stream, call the `start` method. It accepts a block that runs each time a result gets recieved:

```Ruby
stream.start do |location|
  # The streaming events get wrapped inside an ORM-like Class
  puts location.latitude
  puts location.longitude
end
```

The block gets executed inside a separated Thread.
You can close the connection by calling the `close` method:

**WARNING:** This interrupts the connection between ksqlDB and the client.

```Ruby
stream.close
```

Example:

```Ruby
# Define the Stream
stream = Ksql::Client.query_stream("SELECT * FROM riderLocations EMIT CHANGES;")

# Start the connection
stream.start do |location|
  # This code will get executed inside a separated Thread
  puts location.latitude
  puts location.longitude
end

# The code flow goes on
sleep(10)

# Close the connection
stream.close
```

### Pull Query

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

## Close Query

In case you need to close a `Persistent` Query you can do so with the `close_query` method, passing the Query ID:

```Ruby
Ksql::Client.close_query("CTAS_RIDERSNEARMOUNTAINVIEW_5")
```

**WARNING:** There's a known issue here, read [below](#ksqldb-close-query).

## Examples

You can find some implementation examples [here](https://github.com/LapoElisacci/ksql/tree/main/examples).

## Supported ksqlDB versions

| Version |  |
| ------ | -- |
| 0.23.1 | :heavy_check_mark: Supported |
| 0.22.0 | :heavy_check_mark: Supported |
| 0.21.0 | :heavy_check_mark: Supported |
| 0.20.0 | :heavy_check_mark: Supported |
| 0.19.0 | :heavy_check_mark: Supported |
| 0.18.0 | :heavy_check_mark: Supported |
| 0.17.0 | :x: Untested |
| 0.15.0 | :x: Untested |
| 0.14.0 | :x: Untested |
| 0.13.0 | :x: Untested |
| 0.12.0 | :x: Untested |
| 0.11.0 | :x: Untested |
| 0.10.2 | :x: Untested |
| 0.10.1 | :x: Untested |
| 0.10.0 | :x: Untested |
| 0.9.0 | :x: Unsupported |
| 0.8.1 | :x: Unsupported |
| 0.7.1 | :x: Unsupported |

## Known issues

### ksqlDB close-query

Although it actually works, at the moment, the latest release of ksqlDB returns an error each time you request the `/close-query` endpoint.
Therefore the query will correctly get closed but an error will get returned anyways.

ksqlDB Issue [here](https://github.com/confluentinc/ksql/issues/8251).

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rspec spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Make sure you have a working instance of ksqlDB, you can find the official quickstart [here](https://ksqldb.io/quickstart.html).

Each branch must come along with relative Issues and Pull Request.

Please follow the branch naming convention:

1. New feature: `master_dev/#ISSUEID_short_description`
2. Bugfix: `hotfix/#ISSUEID_short_description`

Example:

`master_dev/1_tests`

`hotfix/2_handle_errors`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/LapoElisacci/ksql.

## License

[![Licence](https://img.shields.io/github/license/Ileriayo/markdown-badges?style=for-the-badge)](https://opensource.org/licenses/MIT)

<!--- MARKDOWN LINKS --->

[ruby-shield]: https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white
