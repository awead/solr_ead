require 'solr_ead/railtie' if defined?(Rails)
require 'nokogiri'
require 'solrizer'
require 'om'
require 'rake'
require 'rsolr'
require 'active_support'
require 'yaml'

module SolrEad
  extend ActiveSupport::Autoload

  autoload :Formatting
  autoload :Behaviors
  autoload :OmBehaviors
  autoload :Indexer
  autoload :Document
  autoload :Component

  def self.version
    SolrEad::VERSION
  end
end
