#! /usr/bin/env ruby

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'nokogiri'
  gem 'aws-sdk-ssm'

  gem 'cloud-config', path: '..'
end

require 'benchmark'
require 'cloud-config/cache/in_memory'
require 'cloud-config/providers/aws_parameter_store'

CloudConfig.configure do
  cache_client CloudConfig::Cache::InMemory.new

  provider :aws_parameter_store, preload: true do
    setting :parameter_store_example, cache: 5
  end
end

CloudConfig.preload

value = nil

puts 'Fetching key parameter_store_example (cached)'
time = Benchmark.measure { value = CloudConfig.get(:parameter_store_example) }
puts "Fetched value #{value} in #{time.real.round(5)} seconds"

sleep 5

puts 'Fetching key parameter_store_example'
time = Benchmark.measure { value = CloudConfig.get(:parameter_store_example) }
puts "Fetched value #{value} in #{time.real.round(5)} seconds"
