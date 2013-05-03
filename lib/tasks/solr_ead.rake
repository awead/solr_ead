namespace :solr_ead do

  desc "Index and ead into solr using FILE=<path/to/ead.xml>"
  task :index do
    raise "Please specify your ead, ex. FILE=<path/to/ead.xml>" unless ENV['FILE']
    indexer = load_indexer
    indexer.update(ENV['FILE'])
  end

  desc "Delete and ead from your solr index using ID='<eadid>'"
  task :delete do
    raise "Please specify your ead id, ex. ID=<eadid>" unless ENV['ID']
    indexer = SolrEad::Indexer.new
    indexer.delete(ENV['ID'])
  end

  desc "Index a directory of ead files given by DIR=<path/to/directory>"
  task :index_dir do
    raise "Please specify your directory, ex. DIR=<path/to/directory>" unless ENV['DIR']
    indexer = load_indexer
    Dir.glob(File.join(ENV['DIR'],"*")).each do |file|
      print "Indexing #{File.basename(file)}..."
      indexer.update(file) if File.extname(file).match("xml$")
      print "done.\n"
    end
  end

end

# Set up a new indexer object
# 
# Instantiate a new indexer object with a custom document, component and/or simple switch if present
def load_indexer
  options = {}
  if ENV['CUSTOM_DOCUMENT']
    raise "Please specify a valid file for your custom document." unless File.exists? ENV['CUSTOM_DOCUMENT']
    require File.join(Rails.root, ENV['CUSTOM_DOCUMENT'])
    options[:document] = File.basename(ENV['CUSTOM_DOCUMENT']).split(".").first.classify.constantize
  end
  if ENV['CUSTOM_COMPONENT']
    raise "Please specify a valid file for your custom component." unless File.exists? ENV['CUSTOM_COMPONENT']
    require File.join(Rails.root, ENV['CUSTOM_COMPONENT'])
    options[:component] = File.basename(ENV['CUSTOM_COMPONENT']).split(".").first.classify.constantize
  end
  options[:simple] = (ENV['SIMPLE'] or ENV['SIMPLE']=="true") ? true : false
  indexer = SolrEad::Indexer.new(options)
  return indexer
end