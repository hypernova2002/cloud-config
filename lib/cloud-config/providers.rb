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

      # @!attribute [r] Fetch provider configuration by setting key
      #   @return [Hash<Symbol,ProviderConfig>]
      attr_reader :providers_by_key

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

        update_provider_keys(provider_config)
      end

      # Update {#providers_by_key} with settings from the provider config.
      #
      # @param provider_config [ProviderConfig] Provider config containing the keys
      def update_provider_keys(provider_config)
        @providers_by_key ||= {}
        provider_config.settings.each_key do |key|
          @providers_by_key[key] = provider_config
        end
      end
    end
  end
end
