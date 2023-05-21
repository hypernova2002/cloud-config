# frozen_string_literal: true

require 'aws-sdk-secretsmanager'

module Mocks
  module SecretsManagerClient
    def mock_secrets_manager_client(params = {})
      @secrets_manager_client = Aws::SecretsManager::Client.new(stub_responses: true)

      @secret =
        if params[:secrets]
          params[:secrets].each_with_object({}) do |(key, value), param|
            param[key.to_s] = new_secret(value)
          end
        else
          {}
        end

      @secrets_manager_client.stub_responses(:get_secret_value, lambda { |context|
        unless @secret.key?(context.params[:secret_id])
          raise Aws::SecretsManager::Errors::ResourceNotFoundException.new(context, 'Missing key')
        end

        @secret[context.params[:secret_id]]
      })

      @secrets_manager_client.stub_responses(:put_secret_value, lambda { |context|
        @secret[context.params[:secret_id]] = new_secret(context.params[:secret_string])
      })

      allow(Aws::SecretsManager::Client).to receive(:new).and_return(@secrets_manager_client)
    end

    def new_secret(value)
      Aws::SecretsManager::Types::GetSecretValueResponse.new(secret_string: value)
    end
  end
end
