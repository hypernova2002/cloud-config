# frozen_string_literal: true

module CloudConfig
  module Cache
    # A simple class for storing key-value configuration in-memory. Keys can be individuallly set to
    # expire.
    #
    # @example
    #   cache = CloudConfig::Cache::InMemory.new
    #   cache.set(:key_to_expire, :key_value, expire_in: 5)
    #
    #   cache.get(:key_to_expire) #=> :key_value
    #
    #   sleep 5
    #
    #   cache.get(:key_to_expire) #=> nil
    class InMemory
      # Default time to expire keys (seconds)
      DEFAULT_EXPIRE = 60 * 60

      # @!attribute [r] settings
      #   @return [Hash]
      attr_reader :settings

      def initialize
        @settings = {}
      end

      # Check whether the key exists in the cache. Expired keys will return false.
      #
      # @param key [String,Symbol] Key to check
      #
      # @return [Boolean] Whether key exists
      def key?(key)
        expire(key)

        settings.key?(key)
      end

      # Fetch the key from the cache
      #
      # @param key [String,Symbol] Key to check
      #
      # @return [Object] Value of key
      def get(key)
        expire(key)

        settings.dig(key, :value)
      end

      # Set the value of the key in the cache. Optionally set an expiry of the key, otherwise
      # a default expiry of {DEFAULT_EXPIRE} will be set.
      #
      # @param key [String,Symbol] Key to set
      # @param value [Object] Value of the key
      # @option options [Hash] :expire_in Time in seconds until key expires
      def set(key, value, options = {})
        expire_in = options[:expire_in] || DEFAULT_EXPIRE

        expire_at = Time.now + expire_in

        settings[key] = {
          value:,
          expire_at:
        }
      end

      # Delete the key from the cache
      #
      # @param key [String,Symbol] Key to delete
      def delete(key)
        settings.delete(key)
      end

      # Expire the key from the cache, if the expiry time has passed
      #
      # @param key [String,Symbol] Key to expire
      def expire(key)
        expire_at = settings.dig(key, :expire_at)

        delete(key) if expire_at && expire_at <= Time.now
      end
    end
  end
end
