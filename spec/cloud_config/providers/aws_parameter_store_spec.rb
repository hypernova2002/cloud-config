# frozen_string_literal: true

require_relative '../../../lib/cloud-config/providers/aws_parameter_store'

RSpec.describe CloudConfig::Providers::AwsParameterStore do
  include Mocks::SSMClient

  subject(:provider) { described_class.new(options) }

  let(:options) { {} }
  let(:parameter_key) { :test_parameter }
  let(:parameter_value) { :store_value }

  before do
    mock_ssm_client(parameter: { parameter_key => parameter_value })
  end

  describe 'get' do
    it 'fetches the value of the key' do
      expect(provider.get(parameter_key)).to eql(parameter_value)
    end

    it 'returns nil for missing key' do
      expect { provider.get(:missing) }.to raise_error(Aws::SSM::Errors::ParameterNotFound)
    end

    # rubocop:disable RSpec/InstanceVariable
    context 'with encryption' do
      it 'calls ssm parameter store with with_decryption set to true in `get` method' do
        allow(@ssm_client).to receive(:get_parameter).and_call_original

        provider.get(parameter_key, with_decryption: true)

        expect(@ssm_client).to have_received(:get_parameter).with(name: parameter_key, with_decryption: true)
      end

      it 'calls ssm parameter store with with_decryption set to true in initializer' do
        options[:with_decryption] = true

        allow(@ssm_client).to receive(:get_parameter).and_call_original

        provider.get(parameter_key)

        expect(@ssm_client).to have_received(:get_parameter).with(name: parameter_key, with_decryption: true)
      end
    end
    # rubocop:enable RSpec/InstanceVariable
  end

  describe 'set' do
    let(:set_key) { 'set_value' }

    it 'sets the value of the key' do
      provider.set(:set_key, set_key)

      expect(provider.get(:set_key)).to eql(set_key)
    end
  end
end
