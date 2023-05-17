# frozen_string_literal: true

module CloudConfig
  module Providers
    # A class that acts as a provider for storing configuration in-memory
    #
    # @example
    #   provider = InMemory.new # Assuming AWS credentials are already configured
    #   provider.set(:example_key, :example_value)
    #   provider.get(:example_key) #=> 'example_value'
    class InMemory
      # @!attribute [r] settings
      #   @return [Hash]
      attr_reader :settings

      # Create an instance of {InMemory}
      def initialize(_params = {})
        @settings = {}
      end

      # Fetch the value of the key
      #
      # @param key [String,Symbol] Key to fetch
      #
      # @return [Object] Value of the key
      def get(key)
        settings[key]
      end

      # Set the value of the key
      #
      # @param key [String,Symbol] Key to set
      # @param value [Object] Value of the key
      def set(key, value)
        @settings[key] = value
      end
    end
  end
end
