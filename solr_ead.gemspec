# -*- encoding: utf-8 -*-
require File.expand_path('../lib/solr_ead/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Adam Wead"]
  gem.email         = ["amsterdamos@gmail.com"]
  gem.description   = %q{A gem indexing ead into solr using OM. Define your own OM terminology to create the solr fields you want from your ead, then use solr-based applications like Blacklight to search and display the results.}
  gem.summary       = %q{A gem for indexing ead into solr using OM}
  gem.homepage      = "http://github.com/awead/ead_solr"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "solr_ead"
  gem.require_paths = ["lib"]
  gem.version       = SolrEad::VERSION

  # Dependencies
  gem.add_dependency('om')
  gem.add_dependency('solrizer')
  gem.add_dependency('rsolr')
  gem.add_dependency('sanitize')
  # For Development
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'debugger'
end
