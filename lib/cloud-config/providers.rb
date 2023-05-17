# frozen_string_literal: true

module CloudConfig
  # A module for configuring providers
  module Providers
    # Extend {Providers::ClassMethods} when included
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Class methods for {Providers}
    module ClassMethods
      # @!attribute [r] Provider configurations
      #   @return [Hash<Symbol,ProviderConfig>]
      attr_reader :providers

      # Add a provider to the list of provider configurations.
      #
      # @param provider_name [Symbol] Name of the provider
      # @param provider_options [Hash<Symbol,Object>] Options for configuring the provider
      #
      # @yield A block to be evaluated on an instance of {ProviderConfig}
      def provider(provider_name, provider_options = {}, &blk)
        provider_config = ProviderConfig.new(provider_name, provider_options)
        provider_config.instance_eval(&blk) if blk
        @providers ||= {}
        @providers[provider_name] = provider_config
      end
    end
  end
end
