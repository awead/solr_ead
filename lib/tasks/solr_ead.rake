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

  desc "Index a directory of ead files given by DIR=path/to/directory"
  task :index_dir do
    raise "Please specify your direction, ex. DIR=path/to/directory" unless ENV['DIR']
    indexer = SolrEad::Indexer.new
    Dir.glob(File.join(ENV['DIR'],"*")).each do |file|
      indexer.update(file) if File.extname(file).match("xml$")
    end
  end

end