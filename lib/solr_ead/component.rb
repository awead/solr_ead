class SolrEad::Component

  include OM::XML::Document
  include OM::XML::TerminologyBasedSolrizer

  # Define each term in your ead that you want put into the solr document
  set_terminology do |t|
    t.root(:path=>"c")
    t.ref_(:path=>"/c/@id")
    t.level(:path=>"/c/@level", :index_as=>[:facetable])
    t.title(:path=>"unittitle", :attributes=>{ :type => :none }, :index_as=>[:displayable])
    t.unitdate(:index_as=>[:displayable])

    # Facets
    t.corpname(:index_as=>[:facetable])
    t.famname(:index_as=>[:facetable])
    t.genreform(:index_as=>[:facetable])
    t.geogname(:index_as=>[:facetable])
    t.name(:index_as=>[:facetable])
    t.persname(:index_as=>[:facetable])
    t.subject(:index_as=>[:facetable])

    # Item
    t.container {
      t.label(:path => {:attribute=>"label"})
      t.type(:path => {:attribute=>"type"})
      t.id(:path => {:attribute=>"id"})
    }
    t.container_label(:proxy=>[:container, :label])
    t.container_type(:proxy=>[:container, :type])
    t.container_id(:proxy=>[:container, :id])
    t.material(:proxy=>[:container, :label], :index_as=>[:facetable])
    t.physdesc(:path=>"did/physdesc[not(dimensions)]", :index_as=>[:displayable])
    t.dimensions(:path=>"did/physdesc/dimensions", :index_as=>[:displayable])
    t.langcode(:path=>"did/langmaterial/language/@langcode")
    t.language(:path=>"did/langmaterial", :index_as=>[:displayable])

    # Description
    t.accessrestrict(:path=>"accessrestrict/p", :index_as=>[:displayable])
    t.accessrestrict_heading(:path=>"accessrestrict/head")
    t.accruals(:path=>"accruals/p", :index_as=>[:displayable])
    t.accruals_heading(:path=>"accruals/head")
    t.acqinfo(:path=>"acqinfo/p", :index_as=>[:displayable])
    t.acqinfo_heading(:path=>"acqinfo/head")
    t.altformavail(:path=>"altformavail/p", :index_as=>[:displayable])
    t.altformavail_heading(:path=>"altformavail/head")
    t.appraisal(:path=>"appraisal/p", :index_as=>[:displayable])
    t.appraisal_heading(:path=>"appraisal/head")
    t.arrangement(:path=>"arrangement/p", :index_as=>[:displayable])
    t.arrangement_heading(:path=>"arrangement/head")
    t.custodhist(:path=>"custodhist/p", :index_as=>[:displayable])
    t.custodhist_heading(:path=>"custodhist/head")
    t.fileplan(:path=>"fileplan/p", :index_as=>[:displayable])
    t.fileplan_heading(:path=>"fileplan/head")
    t.originalsloc(:path=>"originalsloc/p", :index_as=>[:displayable])
    t.originalsloc_heading(:path=>"originalsloc/head")
    t.phystech(:path=>"phystech/p", :index_as=>[:displayable])
    t.phystech_heading(:path=>"phystech/head")
    t.processinfo(:path=>"processinfo/p", :index_as=>[:displayable])
    t.processinfo_heading(:path=>"processinfo/head")
    t.relatedmaterial(:path=>"relatedmaterial/p", :index_as=>[:displayable])
    t.relatedmaterial_heading(:path=>"relatedmaterial/head")
    t.separatedmaterial(:path=>"separatedmaterial/p", :index_as=>[:displayable])
    t.separatedmaterial_heading(:path=>"separatedmaterial/head")
    t.scopecontent(:path=>"scopecontent/p", :index_as=>[:displayable])
    t.scopecontent_heading(:path=>"scopecontent/head")
    t.userestrict(:path=>"userestrict/p", :index_as=>[:displayable])
    t.userestrict_heading(:path=>"userestrict/head")
  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    Solrizer.insert_field(solr_doc, "ref", self.ref.first.strip, :stored_sortable)
  end

end