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
# are defined in SolrEad::Document and fields for the component are defined in SolrEad::Component.
#   > file = File.new("path/to/your/ead.xml")
#   > indexer = SolrEad::Indexer.new
#   > indexer.create(file)
#   > indexer.delete("EAD-ID")
#
# ==Simple indexing
# By using the :simple option, SolrEad will create only one solr document from one ead.
# The default implementation of SolrEad is to create multiple documents, so fields
# defined in SolrEad::Document reflect this.  For example, no component fields are defined in
# SolrEad::Document, so none would be indexed.  If you elect to use the :simple option, you'll
# want to override SolrEad::Document with your own and define any additional component fields
# you want to appear in your index.
#   > file = File.new("path/to/your/ead.xml")
#   > indexer = SolrEad::Indexer.new(:simple => true)
#   > indexer.create(file)
#   > indexer.delete("EAD-ID")

class Indexer

  include RSolr
  include SolrEad::Behaviors

  attr_accessor :solr, :options

  # Creates a new instance of SolrEad::Indexer and connects to your solr server
  # using the url supplied in your config/solr.yml file.
  def initialize(opts={})
    Solrizer.default_field_mapper = EadMapper.new
    if ENV['SOLR_URL']
      url = ENV['SOLR_URL']
    elsif defined?(Rails.root)
      url = YAML.load(ERB.new(File.read(File.join(Rails.root,"config","solr.yml"))).result)[Rails.env]['url']
    elsif ENV['RAILS_ENV']
      url = YAML.load(ERB.new(File.read("config/solr.yml")).result)[ENV['RAILS_ENV']]['url']
    else
      url = YAML.load(ERB.new(File.read("config/solr.yml")).result)['development']['url']
    end
    self.solr = RSolr.connect :url => url
    self.options = opts
  end
  
  # Indexes your ead and additional component documents with the supplied file, then
  # commits the results to your solr server.
  def create(file)
    doc = om_document(File.new(file))
    solr_doc = doc.to_solr
    solr.add solr_doc
    add_components(file) unless options[:simple]
    solr.commit
  end

  # Updates your ead from a given file by first deleting the existing ead document and
  # any component documents, then creating a new index from the supplied file.
  # This method will also commit the results to your solr server when complete.
  def update(file)
    doc = om_document(File.new(file))
    solr_doc = doc.to_solr
    solr.delete_by_query( 'ead_id:"' + solr_doc["id"] + '"' )
    solr.add solr_doc
    add_components(file) unless options[:simple]
    solr.commit
  end

  # Deletes the ead document and any component documents from your solr index and
  # commits the results.
  def delete(id)
    solr.delete_by_query( 'ead_id:"' + id + '"')
    solr.commit
  end

  protected

  # Returns an OM document from a given file.
  #
  # Determines if you have specified a custom definition for your ead document.
  # If you've defined a class CustomDocument, and have passed it as an option
  # to your indexer, then SolrEad will use that class instead of SolrEad::Document.
  def om_document(file)
    options[:document] ? options[:document].from_xml(File.new(file)) : SolrEad::Document.from_xml(File.new(file))
  end

  # Returns an OM document from a given Nokogiri node
  #
  # Determines if you have specified a custom definition for your ead component.
  # If you've defined a class CustomComponent, and have passed it as an option
  # to your indexer, then SolrEad will use that class instead of SolrEad::Component.
  def om_component_from_node(node)
    options[:component] ? options[:component].from_xml(prep(node)) : SolrEad::Component.from_xml(prep(node))
  end

  # Creates solr documents for each individual component node in the ead.  Field names
  # and values are determined according to the OM terminology outlined in
  # SolrEad::Component as well as additional fields taken from the rest of the ead
  # document as described in SolrEad::Behaviors#additional_component_fields.
  #
  # Fields from both the terminology and #additional_component_fields are all assembled
  # into one solr document via the SolrEad::Component#to_solr method.  Any customizations to
  # the contents or appearance of the fields can take place within that method.
  #
  # Furthermore, one final field is added to the solr document after the #to_solr method.
  # A sorting field *sort_i* is added to the document using the index values from the array
  # of <c> nodes.  This allows us to preserve the order of <c> nodes as they appear
  # in the original ead document.
  def add_components(file)
    counter = 1
    components(file).each do |node|
      solr_doc = om_component_from_node(node).to_solr(additional_component_fields(node))
      solr_doc.merge!({"sort_i" => counter.to_s})
      solr.add solr_doc
      counter = counter + 1
    end
  end

end
end