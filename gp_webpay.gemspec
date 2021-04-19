require_relative 'lib/gp_webpay/version'

Gem::Specification.new do |spec|
  spec.name = 'gp_webpay'
  spec.version = GpWebpay::VERSION
  spec.authors = ['Lubomir Vnenk']
  spec.email = ['lubomir.vnenk@zoho.com']

  spec.summary = 'Gem for integrating GP Webpay HTTP api and WS recurring payments'
  spec.description = 'Gem for integrating GP Webpay HTTP api and WS recurring payments with multiple merchants'
  spec.homepage = 'https://github.com/lubosch/gp_webpay'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.extra_rdoc_files = %w[README.md changelog.md]
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/lubosch/gp_webpay'
  spec.metadata['changelog_uri'] = 'https://github.com/lubosch/gp_webpay/blob/master/changelog.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  # spec.files = Dir.chdir(File.expand_path(__dir__)) do
  #   `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  # end
  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 1'
  spec.add_dependency 'faraday_middleware', '~> 1'
  spec.add_dependency 'nokogiri', '~> 1'
  spec.add_dependency 'xml-simple', '~> 1'
end
