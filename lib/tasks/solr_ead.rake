require "solr_ead"

namespace :solr_ead do

  desc "Index and ead into solr using FILE=<path/to/ead.xml>"
  task :index do
    raise "Please specify your ead, ex. FILE=<path/to/ead.xml" unless ENV['FILE']
    indexer = SolrEad::Indexer.new
    indexer.update(ENV['FILE'])
  end

  desc "Delete and ead from your solr index using ID='<eadid>'"
  task :delete do
    raise "Please specify your ead id, ex. ID=<eadid>" unless ENV['ID']
    indexer = SolrEad::Indexer.new
    indexer.delete(ENV['ID'])
  end

end