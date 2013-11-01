require 'nokogiri'
require 'solrizer'
require 'om'
require 'rsolr'
require 'active_support'

module SolrEad
  extend ActiveSupport::Autoload

  autoload :Behaviors
  autoload :OmBehaviors
  autoload :Indexer
  autoload :Document
  autoload :Component
  autoload :Railtie if defined?(Rails)


  def self.version
    SolrEad::VERSION
  end
end