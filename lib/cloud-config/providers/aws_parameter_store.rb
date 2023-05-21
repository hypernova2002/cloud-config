# frozen_string_literal: true

module CloudConfig
  module Providers
    # A class for fetching configuration from AWS Parameter Store
    #
    # @example
    #   provider = CloudConfig::Providers::AwsParameterStore.new # Assuming AWS credentials are already configured
    #   provider.set(:example_key, :example_value)
    #   provider.get(:example_key) #=> 'example_value'
    class AwsParameterStore
      # @!attribute [r] An instance of the AWS Parameter Store client
      #   @return [Aws::SSM::Client]
      attr_reader :client

      # @!attribute [r] Whether parameters need to be decrypted
      #   @return [Boolean]
      attr_reader :with_decryption

      # Create a new instance of {AwsParameterStore}.
      #
      # @param [Hash] opts Parameter store options
      # @option opts [Boolean] :with_decryption Whether all keys need to be decrypted
      def initialize(opts = {})
        @client = Aws::SSM::Client.new

        @with_decryption = opts.fetch(:with_decryption, false)
      end

      # Fetch the value of the key
      #
      # @param key [String,Symbol] Key to fetch
      # @param [Hash] opts for fetching the key
      # @option opts [Boolean] :with_decryption Whether the key needs decrypting
      #
      # @return [String] Value of the key
      def get(key, opts = {})
        decrypt = opts.fetch(:with_decryption) { with_decryption }

        client.get_parameter(name: key, with_decryption: decrypt).parameter.value
      end

      # Set the value of the key
      #
      # @param key [String,Symbol] Key to set
      # @param value [Object] Value of the key
      def set(key, value)
        client.put_parameter(name: key, value:)
      end
    end
  end
end
