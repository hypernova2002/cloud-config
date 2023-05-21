# frozen_string_literal: true

module CloudConfig
  module Providers
    # A class for fetching configuration from the AWS Parameter Store
    #
    # @example
    #   provider = CloudConfig::Providers::YamlFile.new # Assuming AWS credentials are already configured
    #   provider.set(:example_key, :example_value)
    #   provider.get(:example_key) #=> 'example_value'
    class YamlFile
      # @!attribute [r] Contents of the Yaml file
      #   @return [Hash]
      attr_reader :contents

      # Create an instance of {YamlFile}
      #
      # @param [Hash] opts Yaml file options
      # @option opts [String] :filename Name of the YAML file
      def initialize(opts = {})
        @contents = YAML.load_file(opts[:filename]) || {}
      end

      # Fetch the value of the key
      #
      # @param key [String,Symbol] Key to fetch
      #
      # @return [Object] Value of the key
      def get(key, _opts = {})
        contents[key]
      end

      # Set the value of the key
      #
      # @param key [String,Symbol] Key to set
      # @param value [Object] Value of the key
      def set(key, value)
        @contents[key] = value
      end
    end
  end
end
