# frozen_string_literal: true

require_relative '../../lib/cloud-config/provider_config'
require_relative '../../lib/cloud-config/providers/in_memory'

RSpec.describe CloudConfig::ProviderConfig do
  subject(:config) { described_class.new(provider_name, provider_options) }

  let(:provider_name) { 'new_provider' }
  let(:provider_options) { { preload: true } }

  describe '#initialize' do
    it 'sets provider_name' do
      expect(config.provider_name).to eql(provider_name)
    end

    it 'sets provider_options' do
      expect(config.provider_options.to_h).to eql(class: nil, preload: true)
    end

    it 'sets settings' do
      expect(config.settings).to eql({})
    end
  end

  describe '#provider_class' do
    it 'gets provider class from string' do
      provider_options[:class] = 'CloudConfig::Providers::InMemory'

      expect(config.provider_class).to eql(CloudConfig::Providers::InMemory)
    end

    it 'gets provider class from class' do
      provider_options[:class] = CloudConfig::Providers::InMemory

      expect(config.provider_class).to eql(CloudConfig::Providers::InMemory)
    end

    context 'with in_memory' do
      let(:provider_name) { :in_memory }

      it 'gets provider class from provider_name' do
        expect(config.provider_class).to eql(CloudConfig::Providers::InMemory)
      end
    end
  end

  describe '#provider' do
    let(:provider_name) { :in_memory }

    it 'returns instance of provider' do
      expect(config.provider).to be_instance_of(CloudConfig::Providers::InMemory)
    end
  end
end
