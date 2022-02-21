![][ruby-shield]

<p align="center">
  <img width="180" src="https://user-images.githubusercontent.com/50866745/147449973-a743b690-fef4-4b97-86d3-cc01f1695118.png" >
</p>

# Ruby KSQL (Under development)

![](https://img.shields.io/static/v1?label=Latest&message=unreleased&color=blue)
![](https://img.shields.io/static/v1?label=Coverage&message=70%&color=yellow)
![](https://img.shields.io/static/v1?label=Test&message=0%&color=red)
![](https://img.shields.io/static/v1?label=Documentation&message=50%&color=important)
![](https://img.shields.io/static/v1?label=Mantained?&message=Yes&color=success)

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
  config.auth = 'user:password' # optional
end
```

### Statements

According to [ksqlDB API Documentation](https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-rest-api/ksql-endpoint/): "All statements, except those starting with `SELECT`, can be run on the `/ksql` endpoint".

The gem provides a method to perform such operations, like so:

```Ruby
Ksql::Http.ksql("SHOW TABLES;")
```

### Queries

According to [ksqlDB API Documentation](https://docs.ksqldb.io/en/latest/developer-guide/ksqldb-rest-api/query-endpoint/), both `Push` and `Pull` Queries 

### Supported ksqlDB versions

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

Issue [here](https://github.com/confluentinc/ksql/issues/8251)


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/LapoElisacci/ksql.

## License

[![Licence](https://img.shields.io/github/license/Ileriayo/markdown-badges?style=for-the-badge)](https://opensource.org/licenses/MIT)

<!--- MARKDOWN LINKS --->

[ruby-shield]: https://img.shields.io/badge/Ruby-CC342D?style=for-the-badge&logo=ruby&logoColor=white
