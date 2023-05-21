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

# @note: Make sure the `parameter_store_example` key is set in the parameter store
CloudConfig.configure do
  cache_client CloudConfig::Cache::InMemory.new

  provider :aws_parameter_store do
    setting :parameter_store_example, cache: 5
  end
end

value = nil

puts 'Fetching key; parameter_store_example'
time = Benchmark.measure { value = CloudConfig.get(:parameter_store_example) }
puts "Fetched value: #{value} in #{time.real.round(5)} seconds"

puts

puts 'Fetching key: parameter_store_example (cached)'
time = Benchmark.measure { value = CloudConfig.get(:parameter_store_example) }
puts "Fetched value: #{value} in #{time.real.round(5)} seconds"

sleep 5

puts

puts 'Fetching key parameter_store_example'
time = Benchmark.measure { value = CloudConfig.get(:parameter_store_example) }
puts "Fetched value #{value} in #{time.real.round(5)} seconds"
