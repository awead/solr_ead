require "nokogiri"
require "solrizer"
require "om"
require "rsolr"

module SolrEad
  def self.version
    SolrEad::VERSION
  end

end

Dir.glob(File.dirname(__FILE__) + '/solr_ead/*', &method(:require))
