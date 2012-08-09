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

    # Default facets
    t.corpname(:index_as=>[:facetable])
    t.famname(:index_as=>[:facetable])
    t.genreform(:index_as=>[:facetable])
    t.geogname(:index_as=>[:facetable])
    t.name(:index_as=>[:facetable])
    t.persname(:index_as=>[:facetable])
    t.subject(:index_as=>[:facetable])

    # Archival material
    t.container(:attributes=>{ :type => "Box" }, :index_as => [:not_searchable, :not_displayable]) {
      t.label(:path=>{ :attribute=>"label" }, :index_as => [:facetable])
    }
    t.material(:proxy=>[:container, :label])

    # These terms are proxied to match with Blacklight's default facets, but otherwise
    # you can remove them or rename the above facet terms to match with your solr
    # implementation.
    t.subject_geo(:proxy=>[:geogname])
    t.subject_topic(:proxy=>[:subject])

    t.accessrestrict(:path=>"accessrestrict/p")
    t.accessrestrict_heading(:path=>"accessrestrict/head", :index_as=>[:not_searchable, :displayable])
    t.accruals(:path=>"accruals/p")
    t.accruals_heading(:path=>"accruals/head", :index_as=>[:not_searchable, :displayable])
    t.acqinfo(:path=>"acqinfo/p")
    t.acqinfo_heading(:path=>"acqinfo/head", :index_as=>[:not_searchable, :displayable])
    t.altformavail(:path=>"altformavail/p")
    t.altformavail_heading(:path=>"altformavail/head", :index_as=>[:not_searchable, :displayable])
    t.appraisal(:path=>"appraisal/p")
    t.appraisal_heading(:path=>"appraisal/head", :index_as=>[:not_searchable, :displayable])
    t.arrangement(:path=>"arrangement/p")
    t.arrangement_heading(:path=>"arrangement/head", :index_as=>[:not_searchable, :displayable])
    t.custodhist(:path=>"custodhist/p")
    t.custodhist_heading(:path=>"custodhist/head", :index_as=>[:not_searchable, :displayable])
    t.fileplan(:path=>"fileplan/p")
    t.fileplan_heading(:path=>"fileplan/head", :index_as=>[:not_searchable, :displayable])
    t.originalsloc(:path=>"originalsloc/p")
    t.originalsloc_heading(:path=>"originalsloc/head", :index_as=>[:not_searchable, :displayable])
    t.phystech(:path=>"phystech/p")
    t.phystech_heading(:path=>"phystech/head", :index_as=>[:not_searchable, :displayable])
    t.processinfo(:path=>"processinfo/p")
    t.processinfo_heading(:path=>"processinfo/head", :index_as=>[:not_searchable, :displayable])
    t.relatedmaterial(:path=>"relatedmaterial/p")
    t.relatedmaterial_heading(:path=>"relatedmaterial/head", :index_as=>[:not_searchable, :displayable])
    t.separatedmaterial(:path=>"separatedmaterial/p")
    t.separatedmaterial_heading(:path=>"separatedmaterial/head", :index_as=>[:not_searchable, :displayable])
    t.scopecontent(:path=>"scopecontent/p")
    t.scopecontent_heading(:path=>"scopecontent/head", :index_as=>[:not_searchable, :displayable])
    t.userestrict(:path=>"userestrict/p")
    t.userestrict_heading(:path=>"userestrict/head", :index_as=>[:not_searchable, :displayable])

  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({"xml_display" => self.to_xml})
    solr_doc.merge!({"format"      => "Archival Item"})
    solr_doc.merge!({"heading_display" => [ solr_doc["parent_unittitle_list_t"], self.title.first ].join(" >> ")  })
  end

end
end