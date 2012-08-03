require "nokogiri"
require "solrizer"
require "om"
require "rsolr"

module SolrEad
  def self.version
    SolrEad::VERSION
  end
end

require "solr_ead/document"
require "solr_ead/component"
require "solr_ead/component_behaviors"
require "solr_ead/indexer"
