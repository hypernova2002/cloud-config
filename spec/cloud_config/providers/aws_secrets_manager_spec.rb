# frozen_string_literal: true

require_relative '../../../lib/cloud-config/providers/aws_secrets_manager'

RSpec.describe CloudConfig::Providers::AwsSecretsManager do
  include Mocks::SecretsManagerClient

  subject(:provider) { described_class.new(options) }

  let(:options) { {} }
  let(:secret_id) { :example_secret_id }
  let(:secret_value) { :example_secret_value }

  before do
    mock_secrets_manager_client(secrets: { secret_id => secret_value })
  end

  describe 'get' do
    it 'fetches the value of the key' do
      expect(provider.get(secret_id)).to eql(secret_value)
    end

    it 'returns nil for missing key' do
      expect { provider.get(:missing) }.to raise_error(Aws::SecretsManager::Errors::ResourceNotFoundException)
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
