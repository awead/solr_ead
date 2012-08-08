module SolrEad
class Document

  include OM::XML::Document
  include Solrizer::XML::TerminologyBasedSolrizer
  include SolrEad::DocumentBehaviors

  # Define each term in your ead that you want put into the solr document
  set_terminology do |t|
    t.root(:path=>"ead", :index_as => [:not_text])

    t.eadid
    t.corpname(:index_as=>[:facetable])
    t.famname(:index_as=>[:facetable])
    t.genreform(:index_as=>[:facetable])
    t.geogname(:index_as=>[:facetable])
    t.name(:index_as=>[:facetable])
    t.persname(:index_as=>[:facetable])
    t.subject(:index_as=>[:facetable])

    t.title(:path=>"titleproper", :attributes=>{ :type => :none })

    t.separatedmaterial(:path=>"archdesc/separatedmaterial/p")
    t.separatedmaterial_heading(:path=>"archdesc/separatedmaterial/head", :index_as=>[:not_text, :displayable])
    t.scopecontent(:path=>"archdesc/scopecontent/p")
    t.scopecontent_heading(:path=>"archdesc/scopecontent/head", :index_as=>[:not_text, :displayable])


  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({"id" => self.eadid.first})
    solr_doc.merge!({"eadid_s" => self.eadid.first})
    solr_doc.merge!({"xml_display" => self.to_xml})
    return solr_doc
  end

  def self.remove_namespaces(file)
    xml = Nokogiri::XML(File.read(file))
    return xml.remove_namespaces!
  end


end
end