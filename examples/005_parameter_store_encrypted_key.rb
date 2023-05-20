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

# @note: Make sure the `encrypted_key` key is set in the parameter store
CloudConfig.configure do
  provider :aws_parameter_store do
    setting :encrypted_key
  end
end

puts 'Fetching key: encrypted_key'
value = CloudConfig.get(:encrypted_key)
puts "Fetched value: #{value}"

puts

puts 'Fetching key: encrypted_key (decrypt)'
value = CloudConfig.get(:encrypted_key, store_options: { with_decryption: true })
puts "Fetched value: #{value}"
