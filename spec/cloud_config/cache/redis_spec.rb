# frozen_string_literal: true

require 'redis'
require 'mock_redis'

require_relative '../../../lib/cloud-config/cache/redis'

RSpec.describe CloudConfig::Cache::Redis do
  subject(:cache) { described_class.new }

  let(:client) { MockRedis.new }

  before do
    allow(Redis).to receive(:new).and_return(client)
  end

  describe '#client' do
    it 'initialises client' do
      expect(cache.client).to eql(client)
    end
  end

  describe 'key?' do
    let(:key1) { 'value1' }

    before do
      client.set(:key1, key1)
    end

    it 'returns true for available key' do
      expect(cache.key?(:key1)).to be true
    end

    it 'returns false for missing key' do
      expect(cache.key?(:missing)).to be false
    end
  end

  describe 'get' do
    let(:key1) { 'value1' }

    before do
      client.set(:key1, key1)
    end

    it 'fetches the value of the key' do
      expect(cache.get(:key1)).to eql(key1)
    end

    it 'returns nil for missing key' do
      expect(cache.get(:missing)).to be_nil
    end
  end

  describe 'set' do
    let(:set_key) { 'set_value' }
    let(:expire_in) { 1800 }

    let(:frozen_time) { Time.local(2008, 9, 1, 10, 5, 0) }

    before do
      Timecop.freeze(frozen_time)
    end

    after do
      Timecop.return
    end

    it 'sets the value of the key' do
      cache.set(:set_key, set_key)

      expect(cache.client.keys).to contain_exactly('set_key')
      expect(cache.client.get(:set_key)).to eql(set_key)
    end

    it 'sets the expiry of the key to the default expiry' do
      cache.set(:set_key, set_key)

      expect(cache.client.keys).to contain_exactly('set_key')
      expect(cache.client.expiration(:set_key)).to eql(frozen_time + cache.class::DEFAULT_EXPIRE)
    end

    it 'sets expiry of key with expire_in set' do
      cache.set(:set_key, set_key, expire_in:)

      expect(cache.client.keys).to contain_exactly('set_key')
      expect(cache.client.expiration(:set_key)).to eql(frozen_time + expire_in)
    end
  end
end
