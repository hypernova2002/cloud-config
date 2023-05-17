# frozen_string_literal: true

module CloudConfig
  # A module for handling the caching of keys.
  module Cache
    # Extend {Cache::ClassMethods} when included
    def self.included(base)
      base.extend(ClassMethods)
    end

    # Class methods for {Cache}
    module ClassMethods
      # @!attribute [r] Cache client instance
      #   @return [Object]
      attr_reader :cache

      # Configure the cache client
      #
      # @param client [Object] Cache client instance
      def cache_client(client)
        @cache = client
      end

      # Fetch the value of the key from the cache, if the key exists in the cache
      #
      # @param key [String,Symbol] Key to fetch from the cache
      # @option options [Hash<Symbol,Object>] Cache options
      #
      # @yield Fetch the value of the key if the key does not exist in the cache
      #
      # @return [Object] Value of the key
      def with_cache(key, options = {})
        return cache.get(key) if cache&.key?(key)

        value = yield

        cache&.set(key, value, options)

        value
      end
    end
  end
end
