require "solr_ead"
require "rsolr"

namespace :solr_ead do


  desc "Index and ead into solr using FILE=<path/to/ead.xml>"
  task :index do
    raise "Please specify your ead, ex, FILE=<path/to/ead.xml" unless ENV['FILE']
    file = File.new(ENV['FILE'])
    doc = SolrEad::Document.from_xml(file)
    solr_doc = doc.to_solr
    puts "Indexing..."

  end







end