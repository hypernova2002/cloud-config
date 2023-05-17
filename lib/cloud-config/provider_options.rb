# frozen_string_literal: true

module CloudConfig
  # A helper class for storing provider options.
  class ProviderOptions
    attr_reader :preload, :klass

    # Create a new instance of {ProviderOptions}.
    #
    # @option param [Hash] :preload Enable preloading for the provider
    # @option param [Hash] :class The class of the provider
    def initialize(params = {})
      @preload = params[:preload]
      @klass = params[:class]
    end

    # Returns whether asynchronous preloading is enabled for the provider.
    #
    # @return [Boolean] Whether asynchronous preloading is enabled
    def async_preload?
      return false unless preload.is_a?(Hash)

      preload[:async]
    end

    # Returns the class in the form of a hash
    #
    # @return [Hash<Symbol,Object>] Class parameters
    def to_h
      { preload:, class: klass }
    end
  end
end
