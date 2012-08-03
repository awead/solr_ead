module SolrEad
class Indexer

  include RSolr
  include SolrEad::ComponentBehaviors

  attr_accessor :solr

  def initialize(opts={})
    if defined?(Rails.root)
      self.solr = RSolr.connect :url => YAML.load_file(File.join(Rails.root,"config","solr.yml"))[Rails.env]['url']
    else
      self.solr = RSolr.connect :url => YAML.load_file("config/solr.yml")['development']['url']
    end
  end

  def create(file,opts={})
    file = File.new(file)
    doc = SolrEad::Document.from_xml(file)
    solr_doc = doc.to_solr
    self.solr.add solr_doc
    add_components file
    self.solr.commit
  end

  def update(file,opts={})
    file = File.new(file)
    doc = SolrEad::Document.from_xml(file)
    solr_doc = doc.to_solr
    self.solr.delete_by_id solr_doc[:id]
    delete_components solr_doc[:id]
    self.solr.add solr_doc
    add_components file
    self.solr.commit
  end

  def delete(id)
    self.solr.delete_by_id id
    delete_components id
    self.solr.commit
  end

  private

  def add_components(file)
    components(file).each do |node|
      solr_doc = SolrEad::Component.from_xml(prep(node)).to_solr
      solr_doc.merge!(additional_component_fields(node))
      #self.solr.add solr_doc
    end
  end

  def delete_components(id)
  end


end
end