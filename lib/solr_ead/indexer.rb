module SolrEad

# The main entry point for your ead going into solr.
#
# SolrEad uses RSolr to connect to your solr server and then gives you a couple of
# simple methods for creating, updating and deleting your ead documents.
#
# You'll need to have your solr configuration defined in config/solr.yml.  If you're
# working within the Rails environment, it will obey your environment settings.  However,
# if you are using the gem by itself outside of rails, you can use the RAILS_ENV environment
# variable, otherwise, it will default to the development url.
#
# ==Default indexing
# This will index your ead into one solr document for the main portion of ead and then
# multiple documents for the component documents.  The fields for the main document
# are defined in EadDocument and fields for the component are defined in EadComponent.
#   > file = File.new("path/to/your/ead.xml")
#   > indexer = SolrEad::Indexer.new
#   > indexer.create(file)
#   > indexer.delete("EAD-ID")
#
# ==Simple indexing
# By using the :simple option, SolrEad will create only one solr document from one ead.
# The default implementation of SolrEad is to create multiple documents, so fields
# defined in EadDocument reflect this.  For example, no component fields are defined in
# EadDocument, so none would be indexed.  If you elect to use the :simple option, you'll
# want to override EadDocument with your own and define any additional component fields
# you want to appear in your index.
#   > file = File.new("path/to/your/ead.xml")
#   > indexer = SolrEad::Indexer.new(:simple => true)
#   > indexer.create(file)
#   > indexer.delete("EAD-ID")

class Indexer

  include RSolr
  include SolrEad::Behaviors

  attr_accessor :solr, :opts

  # Creates a new instance of SolrEad::Indexer and connects to your solr server
  # using the url supplied in your config/solr.yml file.
  def initialize(opts={})
    if defined?(Rails.root)
      url = YAML.load_file(File.join(Rails.root,"config","solr.yml"))[Rails.env]['url']
    elsif ENV['RAILS_ENV']
      url = YAML.load_file(File.join(Rails.root,"config","solr.yml"))[ENV['RAILS_ENV']]['url']
    else
      url = YAML.load_file("config/solr.yml")['development']['url']
    end
    self.solr = RSolr.connect :url => url
    self.opts = opts
  end

  # Indexes your ead and additional component documents with the supplied file, then
  # commits the results to your solr server.
  def create(file)
    doc = EadDocument.from_xml(File.new(file))
    solr_doc = doc.to_solr
    solr.add solr_doc
    add_components(file) unless opts[:simple]
    solr.commit
  end

  # Updates your ead from a given file by first deleting the existing ead document and
  # any component documents, then creating a new index from the supplied file.
  # This method will also commit the results to your solr server when complete.
  def update(file)
    doc = EadDocument.from_xml(File.new(file))
    solr_doc = doc.to_solr
    solr.delete_by_query( 'eadid_s:"' + solr_doc["id"] + '"' )
    solr.add solr_doc
    add_components(file) unless opts[:simple]
    solr.commit
  end

  # Deletes the ead document and any component documents from your solr index and
  # commits the results.
  def delete(id)
    solr.delete_by_query( 'eadid_s:"' + id + '"')
    solr.commit
  end

  protected

  # Creates solr documents for each individual component node in the ead.  Field names
  # and values are determined according to the OM terminology outlined in
  # EadComponent as well as additional fields taken from the rest of the ead
  # document as described in SolrEad::Behaviors#additional_component_fields.
  #
  # Fields from both the terminology and #additional_component_fields are all assembled
  # into one solr document via the EadComponent#to_solr method.  Any customizations to
  # the contents or appearance of the fields can take place within that method.
  #
  # Furthermore, one final field is added to the solr document after the #to_solr method.
  # A sorting field *sort_i* is added to the document using the index values from the array
  # of <c> nodes.  This allows us to preserve the order of <c> nodes as they appear
  # in the original ead document.
  def add_components(file)
    counter = 1
    components(file).each do |node|
      solr_doc = EadComponent.from_xml(prep(node)).to_solr(additional_component_fields(node))
      solr_doc.merge!({"sort_i" => counter.to_s})
      solr.add solr_doc
      counter = counter + 1
    end
  end

end
end