require "solr_ead"

namespace :solr_ead do

  desc "Index and ead into solr using FILE=<path/to/ead.xml>"
  task :index do
    raise "Please specify your ead, ex, FILE=<path/to/ead.xml" unless ENV['FILE']
    indexer = SolrEad::Indexer.new
    indexer.update(ENV['FILE'])
  end

end