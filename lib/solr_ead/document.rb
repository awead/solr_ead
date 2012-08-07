module SolrEad
class Document

  include OM::XML::Document
  include Solrizer::XML::TerminologyBasedSolrizer
  include SolrEad::DocumentBehaviors

  # Define each term in your ead that you want put into the solr document
  set_terminology do |t|
    t.root(:path=>"ead",
           :xmlns=>"urn:isbn:1-931666-22-9",
           :schema=>"http://www.loc.gov/ead/ead.xsd",
           "xmlns:ns2"=>"http://www.w3.org/1999/xlink",
           "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
           :index_as => [:not_text])

    t.eadid
    t.corpname(:index_as=>[:facetable])
    t.famname(:index_as=>[:facetable])
    t.genreform(:index_as=>[:facetable])
    t.geogname(:index_as=>[:facetable])
    t.name(:index_as=>[:facetable])
    t.persname(:index_as=>[:facetable])
    t.subject(:index_as=>[:facetable])

    t.title(:path=>"titleproper", :attributes=>{ :type => :none })

    t.scopecontent(:index_as=>[:not_text]) {
      t.field(:path=>"p")
      t.heading(:path=>"head", :index_as=>[:not_text, :displayable])
    }


  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({"id" => self.eadid.first})
    solr_doc.merge!({"eadid_s" => self.eadid.first})
    solr_doc.merge!({:xml_t => self.to_xml})
    return solr_doc
  end

end
end