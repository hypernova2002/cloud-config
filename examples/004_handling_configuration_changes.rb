#! /usr/bin/env ruby

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'faraday'

  gem 'cloud-config', path: '..'
end

require 'faraday'
require 'cloud-config/cache/in_memory'
require 'cloud-config/providers/in_memory'

CloudConfig.configure do
  cache_client CloudConfig::Cache::InMemory.new

  provider :in_memory, preload: true do
    setting :url, cache: 60
  end
end

CloudConfig.set(:url, 'https://httpstat.us/503')

url = CloudConfig.get(:url)

# Mimick a configuration change
CloudConfig.providers_by_key[:url].provider.set(:url, 'https://httpstat.us/200')

req = Faraday.new do |f|
  f.response :raise_error
  f.response :logger
end

begin
  req.get(url)
rescue Faraday::ServerError
  url = CloudConfig.get(:url, reset_cache: true)

  sleep 1

  retry
end
