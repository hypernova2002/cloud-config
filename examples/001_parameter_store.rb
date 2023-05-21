#! /usr/bin/env ruby

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'nokogiri'
  gem 'aws-sdk-ssm'

  gem 'cloud-config', path: '..'
end

require 'benchmark'
require 'cloud-config/providers/aws_parameter_store'

# @note: Make sure the `parameter_store_example` key is set in the parameter store
CloudConfig.configure do
  provider :aws_parameter_store do
    setting :parameter_store_example
  end
end

puts 'Fetching key: parameter_store_example'
value = CloudConfig.get(:parameter_store_example)
puts "Fetched value: #{value}"
