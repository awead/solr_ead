require "nokogiri"
require "solrizer"
require "om"

module SolrEad
  def self.version
    SolrEad::VERSION
  end
end

require "solr_ead/other_methods"
require "solr_ead/component"
require "solr_ead/document"

