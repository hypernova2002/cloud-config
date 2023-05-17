# frozen_string_literal: true

require 'aws-sdk-ssm'

module Mocks
  module SSMClient
    def mock_ssm_client(params = {})
      @ssm_client = Aws::SSM::Client.new(stub_responses: true)

      @ssm_parameter =
        if params[:parameter]
          params[:parameter].each_with_object({}) do |(key, value), param|
            param[key.to_s] = new_ssm_parameter(value)
          end
        else
          {}
        end

      @ssm_client.stub_responses(:get_parameter, lambda { |context|
        unless @ssm_parameter.key?(context.params[:name])
          raise Aws::SSM::Errors::ParameterNotFound.new(context, 'Missing key')
        end

        @ssm_parameter[context.params[:name]]
      })

      @ssm_client.stub_responses(:put_parameter, lambda { |context|
        @ssm_parameter[context.params[:name]] = new_ssm_parameter(context.params[:value])
      })

      allow(Aws::SSM::Client).to receive(:new).and_return(@ssm_client)
    end

    def new_ssm_parameter(value)
      Aws::SSM::Types::GetParameterResult.new(
        parameter: Aws::SSM::Types::Parameter.new(
          value:
        )
      )
    end
  end
end
