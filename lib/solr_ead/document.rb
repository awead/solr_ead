class SolrEad::Document

  include OM::XML::Document
  include OM::XML::TerminologyBasedSolrizer
  include SolrEad::OmBehaviors
  include SolrEad::Formatting

  # Define each term in your ead that you want put into the solr document
  set_terminology do |t|
    t.root(:path=>"ead")
    t.eadid
    t.title(:path=>"archdesc/did/unittitle", :index_as=>[:searchable, :displayable])
    t.title_filing(:path=>"titleproper", :attributes=>{ :type => "filing" }, :index_as=>[:sortable])
    t.title_num(:path=>"archdesc/did/unitid")
    t.extent(:path=>"archdesc/did/physdesc/extent")
    t.unitdate(:path=>"archdesc/did/unitdate[not(@type)]", :index_as=>[:searchable])
    t.unitdate_bulk(:path=>"archdesc/did/unitdate[@type='bulk']", :index_as=>[:searchable])
    t.unitdate_inclusive(:path=>"archdesc/did/unitdate[@type='inclusive']", :index_as=>[:searchable])
    t.language(:path=>"archdesc/did/langmaterial", :index_as=>[:displayable])
    t.langcode(:path=>"did/langmaterial/language/@langcode")
    t.abstract(:path=>"archdesc/did/abstract", :index_as=>[:searchable])

    # Facets
    t.corpname(:index_as=>[:facetable])
    t.famname(:index_as=>[:facetable])
    t.genreform(:index_as=>[:facetable])
    t.geogname(:index_as=>[:facetable])
    t.name(:index_as=>[:facetable])
    t.persname(:index_as=>[:facetable])
    t.subject(:index_as=>[:facetable])
    t.collection(:proxy=>[:title], :index_as=>[:facetable])

    # General field available within archdesc
    t.accessrestrict(:path=>"archdesc/accessrestrict/p", :index_as=>[:searchable])
    t.accessrestrict_heading(:path=>"archdesc/accessrestrict/head", :index_as=>[:displayable])
    t.accruals(:path=>"archdesc/accruals/p", :index_as=>[:searchable])
    t.accruals_heading(:path=>"archdesc/accruals/head", :index_as=>[:displayable])
    t.acqinfo(:path=>"archdesc/acqinfo/p", :index_as=>[:searchable])
    t.acqinfo_heading(:path=>"archdesc/acqinfo/head", :index_as=>[:displayable])
    t.altformavail(:path=>"archdesc/altformavail/p", :index_as=>[:searchable])
    t.altformavail_heading(:path=>"archdesc/altformavail/head", :index_as=>[:displayable])
    t.appraisal(:path=>"archdesc/appraisal/p", :index_as=>[:searchable])
    t.appraisal_heading(:path=>"archdesc/appraisal/head", :index_as=>[:displayable])
    t.arrangement(:path=>"archdesc/arrangement/p", :index_as=>[:searchable])
    t.arrangement_heading(:path=>"archdesc/arrangement/head", :index_as=>[:displayable])
    t.bioghist(:path=>"archdesc/bioghist/p", :index_as=>[:searchable])
    t.bioghist_heading(:path=>"archdesc/bioghist/head", :index_as=>[:displayable])
    t.bibliography(:path=>"archdesc/bibliography/bibref", :index_as=>[:searchable])
    t.bibliography_heading(:path=>"archdesc/bibliography/head", :index_as=>[:displayable])
    t.custodhist(:path=>"archdesc/custodhist/p", :index_as=>[:searchable])
    t.custodhist_heading(:path=>"archdesc/custodhist/head", :index_as=>[:displayable])
    t.fileplan(:path=>"archdesc/fileplan/p", :index_as=>[:searchable])
    t.fileplan_heading(:path=>"archdesc/fileplan/head", :index_as=>[:displayable])
    t.originalsloc(:path=>"archdesc/originalsloc/p", :index_as=>[:searchable])
    t.originalsloc_heading(:path=>"archdesc/originalsloc/head", :index_as=>[:displayable])
    t.phystech(:path=>"archdesc/phystech/p", :index_as=>[:searchable])
    t.phystech_heading(:path=>"archdesc/phystech/head", :index_as=>[:displayable])
    t.processinfo(:path=>"archdesc/processinfo/p", :index_as=>[:searchable])
    t.processinfo_heading(:path=>"archdesc/processinfo/head", :index_as=>[:displayable])
    t.relatedmaterial(:path=>"archdesc/relatedmaterial/p", :index_as=>[:searchable])
    t.relatedmaterial_heading(:path=>"archdesc/relatedmaterial/head", :index_as=>[:displayable])
    t.separatedmaterial(:path=>"archdesc/separatedmaterial/p", :index_as=>[:searchable])
    t.separatedmaterial_heading(:path=>"archdesc/separatedmaterial/head", :index_as=>[:displayable])
    t.scopecontent(:path=>"archdesc/scopecontent/p", :index_as=>[:searchable])
    t.scopecontent_heading(:path=>"archdesc/scopecontent/head", :index_as=>[:displayable])
    t.userestrict(:path=>"archdesc/userestrict/p", :index_as=>[:searchable])
    t.userestrict_heading(:path=>"archdesc/userestrict/head", :index_as=>[:displayable])

  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({"id" => self.eadid.first.strip})
    Solrizer.insert_field(solr_doc, "ead", self.eadid.first.strip, :stored_sortable)
    return solr_doc
  end

end