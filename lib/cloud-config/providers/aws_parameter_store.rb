# frozen_string_literal: true

module CloudConfig
  module Providers
    # A class for fetching configuration from the AWS Parameter Store
    #
    # @example
    #   provider = AwsParameterStore.new # Assuming AWS credentials are already configured
    #   provider.set(:example_key, :example_value)
    #   provider.get(:example_key) #=> 'example_value'
    class AwsParameterStore
      # @!attribute [r] An instance of the AWS Parameter Store client
      #   @return [Aws::SSM::Client]
      attr_reader :client

      # Create a new instance of {AwsParameterStore}.
      def initialize(_params = {})
        @client = Aws::SSM::Client.new
      end

      # Fetch the value of the key
      #
      # @param key [String,Symbol] Key to fetch
      #
      # @return [String] Value of the key
      def get(key)
        client.get_parameter(name: key).parameter.value
      end

      # Set the value of the key
      #
      # @param key [String,Symbol] Key to set
      # @param value [Object] Value of the key
      def set(key, value)
        client.put_parameter(name: key, value:)
      end

      # def client
      #   @client ||= Aws::SSM::Client.new
      # end
    end
  end
end
