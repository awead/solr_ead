class SolrEad::Document

  include OM::XML::Document
  include Solrizer::XML::TerminologyBasedSolrizer
  include SolrEad::OmBehaviors

  # Define each term in your ead that you want put into the solr document
  set_terminology do |t|
    t.root(:path=>"ead")

    t.eadid(:index_as=>[:string])
    t.corpname(:index_as=>[:facetable])
    t.famname(:index_as=>[:facetable])
    t.genreform(:index_as=>[:facetable])
    t.geogname(:index_as=>[:facetable])
    t.name(:index_as=>[:facetable])
    t.persname(:index_as=>[:facetable])
    t.subject(:index_as=>[:facetable])

    # These terms are proxied to match with Blacklight's default facets, but otherwise
    # you can remove them or rename the above facet terms to match with your solr
    # implementation.
    t.subject_geo(:proxy=>[:geogname])
    t.subject_topic(:proxy=>[:subject])

    t.title(:path=>"titleproper", :attributes=>{ :type => :none }, :index_as=>[:searchable, :displayable])
    t.title_filing(:path=>"titleproper", :attributes=>{ :type => "filing" }, :index_as=>[:sortable])
    t.title_num(:path=>"titleproper/num", :attributes=>{ :type => :none }, :index_as=>[:string])
    t.extent(:path=>"archdesc/did/physdesc/extent", :index_as=>[:searchable])
    t.unitdate(:path=>"archdesc/did/unitdate[not(@type)]", :index_as=>[:searchable])
    t.unitdate_bulk(:path=>"archdesc/did/unitdate[@type='bulk']", :index_as=>[:searchable])
    t.unitdate_inclusive(:path=>"archdesc/did/unitdate[@type='inclusive']", :index_as=>[:searchable])
    t.langmaterial(:path=>"archdesc/did/langmaterial", :index_as=>[:string])
    t.langusage(:path=>"eadheader/profiledesc/langusage", :index_as=>[:string])
    t.abstract(:path=>"archdesc/did/abstract") {
      t.label(:path => {:attribute=>"label"}, :index_as=>[:z])
    }

    t.collection(:path=>"archdesc/did/unittitle", :index_as=>[:facetable, :displayable, :searchable])


    # General field available within archdesc
    t.accessrestrict(:path=>"archdesc/accessrestrict/p", :index_as=>[:searchable])
    t.accessrestrict_heading(:path=>"archdesc/accessrestrict/head", :index_as=>[:z])
    t.accruals(:path=>"archdesc/accruals/p", :index_as=>[:searchable])
    t.accruals_heading(:path=>"archdesc/accruals/head", :index_as=>[:z])
    t.acqinfo(:path=>"archdesc/acqinfo/p", :index_as=>[:searchable])
    t.acqinfo_heading(:path=>"archdesc/acqinfo/head", :index_as=>[:z])
    t.altformavail(:path=>"archdesc/altformavail/p", :index_as=>[:searchable])
    t.altformavail_heading(:path=>"archdesc/altformavail/head", :index_as=>[:z])
    t.appraisal(:path=>"archdesc/appraisal/p", :index_as=>[:searchable])
    t.appraisal_heading(:path=>"archdesc/appraisal/head", :index_as=>[:z])
    t.arrangement(:path=>"archdesc/arrangement/p", :index_as=>[:searchable])
    t.arrangement_heading(:path=>"archdesc/arrangement/head", :index_as=>[:z])
    t.custodhist(:path=>"archdesc/custodhist/p", :index_as=>[:searchable])
    t.custodhist_heading(:path=>"archdesc/custodhist/head", :index_as=>[:z])
    t.fileplan(:path=>"archdesc/fileplan/p", :index_as=>[:searchable])
    t.fileplan_heading(:path=>"archdesc/fileplan/head", :index_as=>[:z])
    t.originalsloc(:path=>"archdesc/originalsloc/p", :index_as=>[:searchable])
    t.originalsloc_heading(:path=>"archdesc/originalsloc/head", :index_as=>[:z])
    t.phystech(:path=>"archdesc/phystech/p", :index_as=>[:searchable])
    t.phystech_heading(:path=>"archdesc/phystech/head", :index_as=>[:z])
    t.processinfo(:path=>"archdesc/processinfo/p", :index_as=>[:searchable])
    t.processinfo_heading(:path=>"archdesc/processinfo/head", :index_as=>[:z])
    t.relatedmaterial(:path=>"archdesc/relatedmaterial/p", :index_as=>[:searchable])
    t.relatedmaterial_heading(:path=>"archdesc/relatedmaterial/head", :index_as=>[:z])
    t.separatedmaterial(:path=>"archdesc/separatedmaterial/p", :index_as=>[:searchable])
    t.separatedmaterial_heading(:path=>"archdesc/separatedmaterial/head", :index_as=>[:z])
    t.scopecontent(:path=>"archdesc/scopecontent/p", :index_as=>[:searchable])
    t.scopecontent_heading(:path=>"archdesc/scopecontent/head", :index_as=>[:z])
    t.userestrict(:path=>"archdesc/userestrict/p", :index_as=>[:searchable])
    t.userestrict_heading(:path=>"archdesc/userestrict/head", :index_as=>[:z])

  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({"id"              => self.eadid.first})
    solr_doc.merge!({"eadid_s"         => self.eadid.first})
    solr_doc.merge!({"format"          => "Archival Collection"})
    solr_doc.merge!({"heading_display" => ("Guide to the " + self.title.first)})
    return solr_doc
  end

end