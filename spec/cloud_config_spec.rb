# frozen_string_literal: true

require_relative '../lib/cloud-config/cache/in_memory'
require_relative '../lib/cloud-config/providers/in_memory'

RSpec.describe CloudConfig do
  subject(:config) { described_class }

  before do
    config.reset!
  end

  describe '.provider' do
    it 'initially empty' do
      expect(config.providers).to be_empty
    end

    context 'without options' do
      before do
        config.configure do
          provider :in_memory
        end
      end

      it 'sets provider' do
        expect(config.providers.keys).to contain_exactly(:in_memory)
        expect(config.providers[:in_memory]).to be_instance_of(CloudConfig::ProviderConfig)
      end
    end

    context 'with options' do
      before do
        config.configure do
          provider :in_memory, preload: true
        end
      end

      it 'sets provider with options' do
        expect(config.providers.keys).to contain_exactly(:in_memory)
        expect(config.providers[:in_memory]).to be_instance_of(CloudConfig::ProviderConfig)
        expect(config.providers[:in_memory].provider_options.to_h).to eql(class: nil, preload: true)
      end
    end
  end

  describe '.providers_by_key' do
    it 'initially empty' do
      expect(config.providers_by_key).to be_empty
    end

    context 'with settings' do
      before do
        config.configure do
          provider :in_memory do
            setting :config_key
          end
        end
      end

      it 'contains correct provider for config_key' do
        expect(config.providers_by_key.keys).to contain_exactly(:config_key)
        expect(config.providers_by_key[:config_key]).to be_instance_of(CloudConfig::ProviderConfig)
        expect(config.providers_by_key[:config_key].settings.key?(:config_key)).to be true
      end

      it 'returns nil for missing key' do
        expect(config.providers_by_key[:missing]).to be_nil
      end
    end
  end

  describe '.cache_client' do
    before do
      config.configure do
        cache_client :config_client
      end
    end

    it 'sets the cache client' do
      expect(config.cache).to be(:config_client)
    end
  end

  describe '.get' do
    let(:setting_value) { 'my_value' }

    before do
      config.configure do
        provider :in_memory do
          setting :my_key
        end
      end

      allow(config.providers[:in_memory].provider).to receive(:get).and_return(setting_value)
    end

    it 'gets key from provider' do
      expect(config.get(:my_key)).to eql(setting_value)
    end

    context 'with cache' do
      before do
        config.configure do
          cache_client CloudConfig::Cache::InMemory.new
        end
      end

      it 'fetches from cache' do
        expect(config.get(:my_key)).to eql(setting_value)
        expect(config.get(:my_key)).to eql(setting_value)

        expect(config.providers[:in_memory].provider).to have_received(:get).once
      end

      it 'resets from cache' do
        expect(config.get(:my_key)).to eql(setting_value)
        expect(config.get(:my_key, reset_cache: true)).to eql(setting_value)

        expect(config.providers[:in_memory].provider).to have_received(:get).twice
      end
    end
  end

  describe '.set' do
    before do
      config.configure do
        provider :in_memory do
          setting :my_key
        end
      end
    end

    it 'gets key from provider' do
      config.set(:my_key, 'key_value')

      expect(config.get(:my_key)).to eql('key_value')
    end
  end

  describe '.reset' do
    before do
      config.configure do
        cache_client :config_client

        provider :in_memory do
          setting :my_key
        end
      end

      config.reset!
    end

    it 'sets cache to nil' do
      expect(config.cache).to be_nil
    end

    it 'sets providers to be empty' do
      expect(config.providers).to be_empty
    end

    it 'sets providers_by_key to be empty' do
      expect(config.providers_by_key).to be_empty
    end
  end
end
