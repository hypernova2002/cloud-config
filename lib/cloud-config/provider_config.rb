# frozen_string_literal: true

require_relative 'provider_options'

module CloudConfig
  # A class for storing provider configuration. Use this class to create a new provider and set the provider
  # parameters.
  class ProviderConfig
    attr_reader :settings, :provider_name, :provider_options

    # Create a new instance of {ProviderConfig}.
    #
    # @param provider_name [String,Symbol] Name of the provider
    # @param provider_options [Hash<Symbol,Object>] List of provider options
    def initialize(provider_name, provider_options)
      @provider_name = provider_name
      @provider_options = ProviderOptions.new(provider_options)
      @settings = {}
    end

    # Store the name of a key with this provider. Provider additional options such as caching.
    #
    # @param setting_name [String,Symbol] Setting key
    # @option setting_options [Hash<Symbol,Object>] List of options for the key
    def setting(setting_name, setting_options = {})
      setting_options = merge_options(setting_options)
      @settings[setting_name] = setting_options
    end

    # Return an instance of the configured provider.
    #
    # @return [Object] Instance of the provider
    def provider
      @provider ||= provider_class.new(provider_options.to_h)
    end

    # Return the class of the configured provider.
    #
    # @return [Object] Class of the provider
    def provider_class
      @provider_class ||= if provider_options.klass
                            generate_class(provider_options.klass)
                          else
                            provider_class_from_name(provider_name)
                          end
    end

    private

    def generate_class(klass)
      return klass unless klass.is_a?(String)

      Object.const_get(klass)
    end

    def provider_class_from_name(class_name)
      capitalised_class_name = class_name.to_s.split('_').map(&:capitalize).join

      CloudConfig::Providers.const_get(capitalised_class_name)
    end

    def merge_options(options)
      options ||= {}

      provider_options.to_h.each do |key, value|
        if options.key?(key)
          options[key] = value.merge(options[key]) if options[key].is_a?(Hash) && value.is_a?(Hash)
        else
          options[key] = value
        end
      end

      options
    end
  end
end
