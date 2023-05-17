# frozen_string_literal: true

require_relative '../../../lib/cloud-config/providers/in_memory'

RSpec.describe CloudConfig::Providers::InMemory do
  subject(:provider) { described_class.new }

  describe '#settings' do
    it 'initialises to empty' do
      expect(provider.settings).to eql({})
    end
  end

  describe 'get' do
    let(:key1) { 'value1' }

    before do
      provider.set(:key1, key1)
    end

    it 'fetches the value of the key' do
      expect(provider.get(:key1)).to eql(key1)
    end

    it 'returns nil for missing key' do
      expect(provider.get(:missing)).to be_nil
    end
  end

  describe 'set' do
    let(:set_key) { 'set_value' }

    it 'sets the value of the key' do
      provider.set(:set_key, set_key)

      expect(provider.settings).to eql(set_key:)
    end
  end
end
