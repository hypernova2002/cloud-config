# frozen_string_literal: true

require 'parallel'

require_relative 'cloud-config/error'
require_relative 'cloud-config/version'
require_relative 'cloud-config/providers'
require_relative 'cloud-config/cache'
require_relative 'cloud-config/provider_config'

# CloudConfig handles fetching key-value configuration settings from multiple providers.
# Configure CloudConfig to handle providers and the configuration keys.
#
# @example
#   CloudConfig.configure do
#     provider :aws_parameter_store, preload: { async: true } do
#       setting :db_url, cache: 60
#       setting :api_url
#     end
#   end
#
module CloudConfig
  include Providers
  include Cache

  module_function

  # Configure {CloudConfig} with providers and their configuration keys
  #
  # @yield Evaluate itself.
  def configure(&)
    instance_eval(&)
  end

  # Fetch the value of a key using the appropriate provider.
  #
  # @param key [String,Symbol] Key to lookup
  # @param reset_cache [Boolean] Whether the cache for the key should be reset
  # @param store_options [Hash] Options used by the datastore when fetching the key
  #
  # @return [Object] Value of the key
  def get(key, reset_cache: false, store_options: {})
    provider_config = providers_by_key[key]

    raise MissingKey, 'Key not found' if provider_config.nil?

    load_key(provider_config, key, reset_cache:, store_options:)
  end

  # Set the value of a key with the configured provider.
  #
  # @param key [String,Symobl] Key to update
  # @param value [Object] Value of key
  def set(key, value)
    provider_config = providers_by_key[key]

    raise MissingKey, 'Key not found' if provider_config.nil?

    provider_config.provider.set(key, value)

    cache&.set(key, value, expire_in: provider_config.settings[key][:cache])
  end

  # Fetch all keys that are configured for preloading. This will automatically
  # cache the corresponding keys.
  def preload
    return if cache.nil?

    providers.each_value do |provider_config|
      next unless provider_config.provider_options.preload

      if provider_config.provider_options.async_preload?
        Parallel.each(provider_config.settings.keys) do |key|
          load_key(provider_config, key)
        end
      else
        provider_config.settings.each_key do |key|
          load_key(provider_config, key)
        end
      end
    end
  end

  # Fetch a key with the provider configuration. If caching is configured, the key
  # will be fetched from the cache.
  #
  # @param provider_config [CloudConfig::ProviderConfig] provider configuration
  # @param key [String,Symbol] Key to fetch
  # @param reset_cache [Boolean] Whether the cache for the key should be reset
  # @param store_options [Hash] Options used by the datastore when fetching the key
  #
  # @return [Object] Value of the key
  def load_key(provider_config, key, reset_cache: false, store_options: {})
    with_cache(key, reset_cache:, expire_in: provider_config.settings[key][:cache]) do
      provider_config.provider.get(key, store_options)
    end
  end

  # Reset the {CloudConfig} configuration
  def reset!
    @cache = nil
    @providers = {}
    @providers_by_key = {}
  end
end

CloudConfig.reset!
