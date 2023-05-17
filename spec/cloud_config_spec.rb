# frozen_string_literal: true

require_relative '../lib/cloud-config/providers/in_memory'

RSpec.describe CloudConfig do
  subject(:config) { described_class }

  before do
    config.reset!
  end

  describe '.provider' do
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
    end

    it 'gets key from provider' do
      allow(config.providers[:in_memory].provider).to receive(:get).and_return(setting_value)

      expect(config.get(:my_key)).to eql(setting_value)
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
end
