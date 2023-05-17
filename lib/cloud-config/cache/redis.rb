# frozen_string_literal: true

module CloudConfig
  module Cache
    # A simple class for storing key-value data in Redis.
    #
    # @example
    #   cache = CloudConfig::Cache::Redis.new(url:)
    #   cache.set(:key_to_expire, :key_value, expire_in: 5)
    #
    #   cache.get(:key_to_expire) #=> :key_value
    #
    #   sleep 5
    #
    #   cache.get(:key_to_expire) #=> nil
    class Redis
      # Default time to expire keys (seconds)
      DEFAULT_EXPIRE = 60 * 60

      # @!attribute [r] Redis client
      #   @return [Redis]
      attr_reader :client

      def initialize(params = {})
        @client = ::Redis.new(params)
      end

      # Check whether the key exists in the cache. Expired keys will return false.
      #
      # @param key [String,Symbol] Key to check
      #
      # @return [Boolean] Whether key exists
      def key?(key)
        client.exists(key) == 1
      end

      # Fetch the key from the cache
      #
      # @param key [String,Symbol] Key to check
      #
      # @return [Object] Value of key
      def get(key)
        client.get(key)
      end

      # Set the value of the key in the cache. Optionally set an expiry of the key, otherwise
      # a default expiry of {DEFAULT_EXPIRE} will be set.
      #
      # @param key [String,Symbol] Key to set
      # @param value [Object] Value of the key
      # @option options [Hash] :expire_in Time in seconds until key expires
      def set(key, value, options = {})
        client.set(key, value, ex: options[:expire_in] || DEFAULT_EXPIRE)
      end

      # Delete the key from the cache
      #
      # @param key [String,Symbol] Key to delete
      def delete(key)
        client.del(key)
      end
    end
  end
end
