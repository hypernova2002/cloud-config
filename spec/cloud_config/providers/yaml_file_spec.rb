# frozen_string_literal: true

require 'fileutils'
require 'yaml'

require_relative '../../../lib/cloud-config/providers/yaml_file'

RSpec.describe CloudConfig::Providers::YamlFile do
  subject(:provider) { described_class.new(filename:) }

  let(:base_folder) { 'yaml_provider_specs' }
  let(:filename) do
    FileUtils.rm_rf(base_folder)
    dir = Dir.mktmpdir(base_folder)
    File.join(dir, 'example.yml')
  end

  before do
    FileUtils.touch(filename)
  end

  after do
    FileUtils.rm_rf(base_folder)
  end

  describe 'get' do
    let(:key1) { 'value1' }

    before do
      File.write(filename, { key1: }.to_yaml)
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

      expect(provider.get(:set_key)).to eql(set_key)
    end
  end
end
