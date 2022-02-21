# frozen_string_literal: true

require_relative 'lib/ksql/version'

Gem::Specification.new do |spec|
  spec.name = 'ksql'
  spec.version = Ksql::VERSION
  spec.authors = ['Lapo Elisacci']
  spec.email = ['lapoelisacci@gmail.com']

  spec.summary = 'Kafka ksqlDB Client for Ruby'
  spec.description = 'A lightweight Ruby client for Kafka ksqlDB'
  spec.homepage = 'https://github.com/LapoElisacci/ksql.git'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.6.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/LapoElisacci/ksql.git'
  spec.metadata['changelog_uri'] = 'https://github.com/LapoElisacci/ksql/blob/main/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 5'
  spec.add_dependency 'hashie', '~> 4'
  spec.add_dependency 'net-http2', '~> 0'
end
