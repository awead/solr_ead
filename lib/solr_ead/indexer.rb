module SolrEad

# A solr indexer for your ead.
#   > file = File.new("path/to/your/ead.xml")
#   > indexer = SolrEad::Indexer.new
#   > indexer.create(file)
#   > indexer.delete("EAD-ID")
class Indexer

  include RSolr
  include SolrEad::ComponentBehaviors

  attr_accessor :solr

  # Creates a new instance of SolrEad::Indexer and connects to your solr server
  # using the url supplied in your config/solr.yml file.
  def initialize(opts={})
    if defined?(Rails.root)
      self.solr = RSolr.connect :url => YAML.load_file(File.join(Rails.root,"config","solr.yml"))[Rails.env]['url']
    else
      self.solr = RSolr.connect :url => YAML.load_file("config/solr.yml")['development']['url']
    end
  end

  # Indexes your ead and additional component documents with the supplied file, then
  # commits the results to your solr server.
  def create(file,opts={})
    doc = SolrEad::Document.from_xml(File.new(file))
    solr_doc = doc.to_solr
    self.solr.add solr_doc
    add_components file
    self.solr.commit
  end

  # Updates your ead from a given file by first deleting the existing ead document and
  # any component documents, then creating a new index from the supplied file.
  # This method will also commit the results to your solr server when complete.
  def update(file,opts={})
    doc = SolrEad::Document.from_xml(File.new(file))
    solr_doc = doc.to_solr
    self.solr.delete_by_query( 'eadid_s:"' + solr_doc["id"] + '"' )
    self.solr.add solr_doc
    add_components file
    self.solr.commit
  end

  # Deletes the ead document and any component documents from your solr index and
  # commits the results.
  def delete(id)
    self.solr.delete_by_query( 'eadid_s:"' + id + '"')
    self.solr.commit
  end

  protected

  # Creates solr documents for each individual component node in the ead.  Field names
  # and values are determined according to the OM terminology outlined in
  # SolrEad::Component as well as additional fields taken from the rest of the ead
  # document as described in SolrEad::ComponentBehaviors#additional_component_fields
  #
  # Furthermore, a solr sorting field *sort_i* is added to the document using the index values from the array
  # of <c> nodes.  This maintains the order of <c> nodes as they appear in the original ead document.
  def add_components(file)
    counter = 1
    components(file).each do |node|
      solr_doc = SolrEad::Component.from_xml(prep(node)).to_solr(additional_component_fields(node))
      solr_doc.merge!({"sort_i" => counter.to_s})
      self.solr.add solr_doc
      counter = counter + 1
    end
  end

end
end