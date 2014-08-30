# -*- encoding: utf-8 -*-
require File.expand_path('../lib/solr_ead/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Adam Wead"]
  gem.email         = ["amsterdamos@gmail.com"]
  gem.description   = %q{A gem for indexing ead into solr using OM. Define your own OM terminology to create the solr fields you want from your ead, then use solr-based applications like Blacklight to search and display the results.}
  gem.summary       = %q{A gem for indexing ead into solr using OM}
  gem.homepage      = "http://github.com/awead/solr_ead"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.name          = "solr_ead"
  gem.require_paths = ["lib"]
  gem.version       = SolrEad::VERSION
  gem.license       = "Apache 2"

  # Dependencies
  gem.add_dependency 'om', '~> 3.0.0'
  gem.add_dependency 'solrizer', '~> 3.1.0'
  gem.add_dependency 'rsolr'
  gem.add_dependency 'sanitize'

  gem.add_development_dependency 'yard'
  gem.add_development_dependency 'redcarpet'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 2.99'
  gem.add_development_dependency 'byebug'
  gem.add_development_dependency 'rdoc'
  gem.add_development_dependency 'jettywrapper'
end
