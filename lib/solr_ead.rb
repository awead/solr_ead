require "nokogiri"
require "solrizer"
require "om"
require "rsolr"

module SolrEad
  def self.version
    SolrEad::VERSION
  end
end

require "ead_mapper"
require "solr_ead/terminology_based_solrizer"
require "solr_ead/document_behaviors"
require "solr_ead/document"
require "solr_ead/component_behaviors"
require "solr_ead/component"
require "solr_ead/indexer"

require 'solr_ead/railtie' if defined?(Rails)