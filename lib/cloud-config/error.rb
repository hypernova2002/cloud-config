# frozen_string_literal: true

module CloudConfig
  # Base error class for {CloudConfig}
  class Error < StandardError; end

  # Raise MissingKey error when the key is not configured.
  class MissingKey < Error; end
end
