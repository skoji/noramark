# -*- encoding: utf-8 -*-
require File.expand_path('../lib/nora_mark/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["KOJIMA Satoshi"]
  gem.email         = ["skoji@mac.com"]
  gem.description   = %q{simple and customizable text markup language for EPUB}
  gem.summary       = %q{simple and customizable text markup language for EPUB}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "nora_mark"
  gem.require_paths = ["lib"]
  gem.version       = NoraMark::VERSION

  gem.required_ruby_version = '>= 2.0.0'
  gem.add_dependency "kpeg"
  gem.add_development_dependency "rspec", "~> 2.14"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "nokogiri", "~> 1.6.0"
end
