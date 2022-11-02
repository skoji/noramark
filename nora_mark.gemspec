# -*- encoding: utf-8 -*-

require File.expand_path('../lib/nora_mark/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["KOJIMA Satoshi"]
  gem.email         = ["skoji@mac.com"]
  gem.description   = %q{Simple and customizable text markup language for EPUB/XHTML}
  gem.summary       = %q{Simple and customizable text markup language for EPUB/XHTML}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "nora_mark"
  gem.require_paths = ["lib"]
  gem.version       = NoraMark::VERSION

  gem.required_ruby_version = '>= 3.0.0'
  gem.add_dependency "kpeg", "1.3.2"
  gem.add_development_dependency "debug"
  gem.add_development_dependency "tilt", ">= 2.0"
  gem.add_development_dependency "rspec", ">= 2.14"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "nokogiri", ">= 1.13.6", "< 2.0"
end
