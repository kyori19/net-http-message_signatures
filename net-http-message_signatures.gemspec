# frozen_string_literal: true

require_relative 'lib/net/http/message_signatures/version'

Gem::Specification.new do |spec|
  spec.name = 'net-http-message_signatures'
  spec.version = Net::HTTP::MessageSignatures::VERSION
  spec.authors = ['kyori19']
  spec.email = ['kyori@accelf.net']

  spec.summary = 'A Ruby implementation of HTTP Message Signatures'
  spec.homepage = 'https://github.com/kyori19/net-http-message_signatures'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.2'

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/kyori19/net-http-message_signatures'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'net-http-structured_field_values', '~> 0.3.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
