# -*- encoding: utf-8 -*-
require File.expand_path('../lib/strap/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Matt Fordham"]
  gem.email         = ["matt@revolvercreative.com"]
  gem.description   = %q{Bootstrap new projects based on a template Git repo}
  gem.summary       = %q{A simple tool for bootstrapping new projects based on a template Git repo}
  gem.homepage      = "http://github.com/mattfordham/Strap"

  gem.files         = `git ls-files`.split($\)
  # gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.executables   = "strap"
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "strap"
  gem.require_paths = ["lib"]
  gem.version       = Strap::VERSION
  
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'debugger'
  gem.add_development_dependency 'guard'
  gem.add_development_dependency 'guard-minitest'
  gem.add_development_dependency 'rb-fsevent'
  gem.add_runtime_dependency "thor"
  gem.add_runtime_dependency "mysql"
end
