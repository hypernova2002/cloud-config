# CloudConfig

A library to modernise the way applications fetch configuration. Typically an application will use environment variables and settings files to store and retrieve configurations, but there are many issues with this approach. Often environment variables create a security risk and settings files hard code infrastructure dependencies into the code. Changing configuration settings will usually require redeploying large parts of the infrastructure and perhaps even need to go through the application deployment lifecycle.

A modern approach stores configuration remotely, often using key/value databases. Storing configurations in a single database, separately from the codebase reduces infrastructure dependency. Configuration updates can automatically sync with any application, without requiring redeployments. Security risk is greatly reduced, since configurations can be securely stored. Another goal with this approach is creating an environmentless codebase. The application no longer needs to know which environment it's running in, since all the configuration is handled by the infrastucture.

Another common problem is password rotation. A typical application will need to be restarted or even redeployed when the configuration settings change. CloudConfig can handle this elegantly, improving application uptime and resilience.

## Installation

Install the gem and add to the application's Gemfile by executing:

    $ bundle add cloud-config

If bundler is not being used to manage dependencies, install the gem by executing:

    $ gem install cloud-config

## Usage

CloudConfig can be configured to fetch keys from multiple providers. Since CloudConfig will need to know which provider has the correct key, all the keys will need to be preconfigured. Duplicate keys will be overriden with the latest provider. An example configuration may look like

```ruby
CloudConfig.configure do
  provider :aws_parameter_store, preload: { async: true } do
    setting :db_url, cache: 60
    setting :api_url
  end
end
```

Fetch a setting with

```ruby
url = CloudConfig.get(:api_url)
```

If caching has been configured, the cache can be reset using

```ruby
url = CloudConfig.get(:api_url, reset_cache: true)
```

### Configuration Options

```ruby
CloudConfig.configure do
  # Set the cache client
  cache_client CloudConfig::Cache::InMemory.new

  # Configure a provider. You can use the built-in providers (:in_memory, :aws_parameter_store, :yaml_file).
  provider :in_memory do
  end

  # If you want to configure a custom provider, then please you will need to set the provider_class option.
  provider :custom_provider, provider_class: CustomProvider do
  end

  # Set the preload option, to enable cache preloading for the provider
  provider :in_memory, preload: true do
  end

  # Add parallelism for faster preloading
  provider :in_memory, preload: { async: true } do
  end

  # Configure some keys for a provider
  provider :in_memory do
    setting :key1
    setting :key2
    setting :key3
  end

  # Configure the setting to be cacheable
  provider :in_memory do
    setting :key1, cache: 60 # 60 seconds
  end

  # If the datastore has configurable options
  provider :aws_parameter_store do
    setting :key1, with_decryption: true
  end
end
```

### Preloading

CloudConfig can preload all the keys configured for preload enabled providers. A cache client must also be configured, otherwise
preloading won't do anything.

```ruby
CloudConfig.configure do
  cache_client CloudConfig::Cache::InMemory.new

  provider :in_memory, preload: true do
    setting :key1
  end
end
```

Call preload to cache all the keys.

```ruby
CloudConfig.preload
```

### Custom Providers

CloudConfig comes equipped with a set of providers for fetching configuration from remote datastores. The limit set of providers will not be sufficient for most real world applications, so creating custom providers will be necessary. There is a very simple interface consisting of 3 methods necessary for creating a custom provider.

```ruby
class CustomProvider
  # Define initialize with a params argument.
  def initialize(params = {}); end

  # Define `get` for fetching keys from the remote datastore
  def get(key, opts = {}); end

  # Define `set` for storing keys in the remote datastore
  def set(key, value); end
end
```

Specify the class when configuring the custom provider.

```ruby
CloudConfig.configure do
  provider :custom_provider, provider_class: CustomProvider do
  end
end
```

### Custom Cache

Defining a custom cache client will require an interface of 3 methods.

```ruby
class CustomCache
  # Define `key?` for checking whether the key exists in the cache client.
  # This check allows nil values to be cached.
  def key?(key); end

  # Define `get` for fetching keys from the cache
  def get(key); end

  # Define `set` for storing keys in the cache
  def set(key, value); end
end
```

Configure CloudConfig to use the cache in the usual way

```ruby
CloudConfig.configure do
  cache_client CustomCache.new
end
```

## Connection Pooling

CloudConfig does not do any connection pooling. It is the responsibility of the application to handle connection pooling. For example, Rails handles its own connection pools, so CloudConfig will not attempt to interfere with the pool.

## Examples

There are some example configurations in the [examples](examples) folder. In the terminal, execute

    $ examples/001_parameter_store.rb

These examples make use of AWS infrastructure, so make sure the AWS enviroment variables have been correctly configured.

    $ export AWS_ACCESS_KEY_ID=
    $ export AWS_SECRET_ACCESS_KEY=
    $ export AWS_REGION=

## Development

It's recommended to use Docker when working with this library. Assuming Docker is installed, run

    $ docker-compose run config /bin/bash

Run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Documentation

Documentation is built using Yardoc. To build the docs, run

    $ yardoc

To view the documentation, run

    $ yard server -r

or using the docker service

    $ docker-compose up yardoc

The documentation is viewable in the browser at [http://localhost:8808](http://localhost:8808)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hypernova2002/cloud-config. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/hypernova2002/cloud-config/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CloudConfig project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hypernova2002/cloud-config/blob/main/CODE_OF_CONDUCT.md).
