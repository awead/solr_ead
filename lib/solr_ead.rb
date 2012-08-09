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
require "terminology_based_solrizer"
require "solr_ead/behaviors"
require "solr_ead/om_behaviors"
require "solr_ead/indexer"
require "ead_document"
require "ead_component"

require 'solr_ead/railtie' if defined?(Rails)