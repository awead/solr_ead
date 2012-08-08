module SolrEad
class Component

  include OM::XML::Document
  include Solrizer::XML::TerminologyBasedSolrizer

  # Define each term in your ead that you want put into the solr document
  set_terminology do |t|
    t.root(:path=>"c", :index_as => [:not_searchable, :not_displayable])
    t.ref(:path=>"/c/@id")
    t.level(:path=>"/c/@level", :index_as => [:facetable])

    t.title(:path=>"unittitle", :attributes=>{ :type => :none }, :index_as=>[:searchable, :displayable])

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

    t.accessrestrict(:path=>"archdesc/accessrestrict/p")
    t.accessrestrict_heading(:path=>"archdesc/accessrestrict/head", :index_as=>[:not_searchable, :displayable])
    t.accruals(:path=>"archdesc/accruals/p")
    t.accruals_heading(:path=>"archdesc/accruals/head", :index_as=>[:not_searchable, :displayable])
    t.acqinfo(:path=>"archdesc/acqinfo/p")
    t.acqinfo_heading(:path=>"archdesc/acqinfo/head", :index_as=>[:not_searchable, :displayable])
    t.altformavail(:path=>"archdesc/altformavail/p")
    t.altformavail_heading(:path=>"archdesc/altformavail/head", :index_as=>[:not_searchable, :displayable])
    t.appraisal(:path=>"archdesc/appraisal/p")
    t.appraisal_heading(:path=>"archdesc/appraisal/head", :index_as=>[:not_searchable, :displayable])
    t.arrangement(:path=>"archdesc/arrangement/p")
    t.arrangement_heading(:path=>"archdesc/arrangement/head", :index_as=>[:not_searchable, :displayable])
    t.custodhist(:path=>"archdesc/custodhist/p")
    t.custodhist_heading(:path=>"archdesc/custodhist/head", :index_as=>[:not_searchable, :displayable])
    t.fileplan(:path=>"archdesc/fileplan/p")
    t.fileplan_heading(:path=>"archdesc/fileplan/head", :index_as=>[:not_searchable, :displayable])
    t.originalsloc(:path=>"archdesc/originalsloc/p")
    t.originalsloc_heading(:path=>"archdesc/originalsloc/head", :index_as=>[:not_searchable, :displayable])
    t.phystech(:path=>"archdesc/phystech/p")
    t.phystech_heading(:path=>"archdesc/phystech/head", :index_as=>[:not_searchable, :displayable])
    t.processinfo(:path=>"archdesc/processinfo/p")
    t.processinfo_heading(:path=>"archdesc/processinfo/head", :index_as=>[:not_searchable, :displayable])
    t.relatedmaterial(:path=>"archdesc/relatedmaterial/p")
    t.relatedmaterial_heading(:path=>"archdesc/relatedmaterial/head", :index_as=>[:not_searchable, :displayable])
    t.separatedmaterial(:path=>"archdesc/separatedmaterial/p")
    t.separatedmaterial_heading(:path=>"archdesc/separatedmaterial/head", :index_as=>[:not_searchable, :displayable])
    t.scopecontent(:path=>"archdesc/scopecontent/p")
    t.scopecontent_heading(:path=>"archdesc/scopecontent/head", :index_as=>[:not_searchable, :displayable])
    t.userestrict(:path=>"archdesc/userestrict/p")
    t.userestrict_heading(:path=>"archdesc/userestrict/head", :index_as=>[:not_searchable, :displayable])

  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({"xml_display" => self.to_xml})
    solr_doc.merge!({"format"      => "Archival Item"})
  end

end
end