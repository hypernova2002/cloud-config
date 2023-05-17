# frozen_string_literal: true

require_relative 'lib/cloud-config/version'

Gem::Specification.new do |spec|
  spec.name = 'cloud-config'
  spec.version = CloudConfig::VERSION
  spec.authors = ['hypernova2002']
  spec.email = ['hypernova2002@gmail.com']

  spec.summary = 'A library for dynamically reloading settings from cloud services'
  spec.description = <<~DOC
        Modernise applications by fetching and caching remote settings. No longer store settings
    in the codebase or as environment variables.
  DOC
  spec.homepage = 'http://github.com/hypernova2002/cloud-config'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'parallel'

  spec.add_development_dependency 'aws-sdk-ssm'
  spec.add_development_dependency 'mock_redis'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rack'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'redis'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'timecop'
  spec.add_development_dependency 'webrick'
  spec.add_development_dependency 'yard'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
