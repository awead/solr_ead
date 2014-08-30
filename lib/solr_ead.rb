require 'nokogiri'
require 'solrizer'
require 'om'
require 'rsolr'
require 'active_support'
require 'yaml'

# Load these rake tasks when the gem is included in a Rails application
Dir[File.expand_path(File.join(File.dirname(__FILE__),"../tasks/*.rake"))].each { |ext| load ext } if defined?(Rake)

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
