module SolrEad
class Indexer

  include RSolr

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
    xml = SolrEad::OtherMethods.ead_rake_xml(file)


    self.solr.commit
  end

  def update(file,opts={})
    file = File.new(file)
    doc = SolrEad::Document.from_xml(file)
    solr_doc = doc.to_solr
    self.solr.delete_by_id solr_doc[:id]
    self.solr.add solr_doc
    self.solr.commit
  end

  def delete(id)
    self.solr.delete_by_id id
    self.solr.commit
  end


end
end