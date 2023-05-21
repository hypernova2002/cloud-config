# frozen_string_literal: true

module CloudConfig
  module Providers
    # A class for fetching configuration from AWS Secrets Manager
    #
    # @example
    #   provider = CloudConfig::Providers::AwsSecretsManager.new # Assuming AWS credentials are already configured
    #   provider.set(:example_key, :example_value)
    #   provider.get(:example_key) #=> 'example_value'
    class AwsSecretsManager
      # @!attribute [r] An instance of the AWS Secrets Manager client
      #   @return [Aws::SSM::Client]
      attr_reader :client

      # Create a new instance of {AwsSecretsManager}.
      def initialize(_opts = {})
        @client = Aws::SecretsManager::Client.new
      end

      # Fetch the value of the key
      #
      # @param key [String,Symbol] Key to fetch
      #
      # @return [String] Value of the key
      def get(key, _opts = {})
        secret = client.get_secret_value(secret_id: key)

        secret.secret_binary || secret.secret_string
      end

      # Set the value of the key
      #
      # @param key [String,Symbol] Key to set
      # @param value [Object] Value of the key
      def set(key, value)
        client.put_secret_value(secret_id: key, secret_string: value)
      end
    end
  end
end
