# frozen_string_literal: true

require 'timecop'

require_relative '../lib/cloud-config'

require_relative 'mocks/secrets_manager_client'
require_relative 'mocks/ssm_client'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
