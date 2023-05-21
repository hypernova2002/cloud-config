#! /usr/bin/env ruby

require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'

  gem 'nokogiri'
  gem 'aws-sdk-secretsmanager'

  gem 'cloud-config', path: '..'
end

require 'cloud-config/providers/aws_secrets_manager'

# @note: Make sure the `secret_example` key is set in AWS Secrets Manager
CloudConfig.configure do
  provider :aws_secrets_manager do
    setting :secret_example
  end
end

puts 'Fetching key: secret_example'
value = CloudConfig.get(:secret_example)
puts "Fetched value: #{value}"
