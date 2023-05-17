# frozen_string_literal: true

module CloudConfig
  module Providers
    # A class for fetching configuration from the AWS Parameter Store
    #
    # @example
    #   provider = YamlFile.new # Assuming AWS credentials are already configured
    #   provider.set(:example_key, :example_value)
    #   provider.get(:example_key) #=> 'example_value'
    class YamlFile
      # @!attribute [r] Contents of the Yaml file
      #   @return [Hash]
      attr_reader :contents

      # Create an instance of {YamlFile}
      #
      # @option params [Hash] :filename Name of the YAML file
      def initialize(params = {})
        @contents = YAML.load_file(params[:filename]) || {}
      end

      # Fetch the value of the key
      #
      # @param key [String,Symbol] Key to fetch
      #
      # @return [Object] Value of the key
      def get(key)
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
