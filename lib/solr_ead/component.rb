class SolrEad::Component

  include OM::XML::Document
  include Solrizer::XML::TerminologyBasedSolrizer

  # Define each term in your ead that you want put into the solr document
  set_terminology do |t|
    t.root(:path=>"c")
    t.ref_(:path=>"/c/@id", :index_as=>[:string])
    t.level(:path=>"/c/@level", :index_as => [:facetable])

    t.title(:path=>"unittitle", :attributes=>{ :type => :none }, :index_as=>[:searchable])
    t.unitdate(:index_as=>[:searchable])

    # Default facets
    t.corpname(:index_as=>[:facetable])
    t.famname(:index_as=>[:facetable])
    t.genreform(:index_as=>[:facetable])
    t.geogname(:index_as=>[:facetable])
    t.name(:index_as=>[:facetable])
    t.persname(:index_as=>[:facetable])
    t.subject(:index_as=>[:facetable])

    # Archival material
    t.container {
      t.label(:path => {:attribute=>"label"})
      t.type(:path => {:attribute=>"type"})
      t.id(:path => {:attribute=>"id"})
    }
    t.container_label(:proxy=>[:container, :label], :index_as => [:searchable])
    t.container_type(:proxy=>[:container, :type], :index_as => [:searchable])
    t.container_id(:proxy=>[:container, :id], :index_as => [:searchable])
    t.material(:proxy=>[:container, :label], :index_as => [:facetable])

    # These terms are proxied to match with Blacklight's default facets, but otherwise
    # you can remove them or rename the above facet terms to match with your solr
    # implementation.
    t.subject_geo(:proxy=>[:geogname])
    t.subject_topic(:proxy=>[:subject])

    t.accessrestrict(:path=>"accessrestrict/p", :index_as=>[:searchable])
    t.accessrestrict_heading(:path=>"accessrestrict/head", :index_as=>[:displayable, :not_searchable])
    t.accruals(:path=>"accruals/p", :index_as=>[:searchable])
    t.accruals_heading(:path=>"accruals/head", :index_as=>[:displayable, :not_searchable])
    t.acqinfo(:path=>"acqinfo/p", :index_as=>[:searchable])
    t.acqinfo_heading(:path=>"acqinfo/head", :index_as=>[:displayable, :not_searchable])
    t.altformavail(:path=>"altformavail/p", :index_as=>[:searchable])
    t.altformavail_heading(:path=>"altformavail/head", :index_as=>[:displayable, :not_searchable])
    t.appraisal(:path=>"appraisal/p", :index_as=>[:searchable])
    t.appraisal_heading(:path=>"appraisal/head", :index_as=>[:displayable, :not_searchable])
    t.arrangement(:path=>"arrangement/p", :index_as=>[:searchable])
    t.arrangement_heading(:path=>"arrangement/head", :index_as=>[:displayable, :not_searchable])
    t.custodhist(:path=>"custodhist/p", :index_as=>[:searchable])
    t.custodhist_heading(:path=>"custodhist/head", :index_as=>[:displayable, :not_searchable])
    t.fileplan(:path=>"fileplan/p", :index_as=>[:searchable])
    t.fileplan_heading(:path=>"fileplan/head", :index_as=>[:displayable, :not_searchable])
    t.originalsloc(:path=>"originalsloc/p", :index_as=>[:searchable])
    t.originalsloc_heading(:path=>"originalsloc/head", :index_as=>[:displayable, :not_searchable])
    t.phystech(:path=>"phystech/p", :index_as=>[:searchable])
    t.phystech_heading(:path=>"phystech/head", :index_as=>[:displayable, :not_searchable])
    t.processinfo(:path=>"processinfo/p", :index_as=>[:searchable])
    t.processinfo_heading(:path=>"processinfo/head", :index_as=>[:displayable, :not_searchable])
    t.relatedmaterial(:path=>"relatedmaterial/p", :index_as=>[:searchable])
    t.relatedmaterial_heading(:path=>"relatedmaterial/head", :index_as=>[:displayable, :not_searchable])
    t.separatedmaterial(:path=>"separatedmaterial/p", :index_as=>[:searchable])
    t.separatedmaterial_heading(:path=>"separatedmaterial/head", :index_as=>[:displayable, :not_searchable])
    t.scopecontent(:path=>"scopecontent/p", :index_as=>[:searchable])
    t.scopecontent_heading(:path=>"scopecontent/head", :index_as=>[:displayable, :not_searchable])
    t.userestrict(:path=>"userestrict/p", :index_as=>[:searchable])
    t.userestrict_heading(:path=>"userestrict/head", :index_as=>[:displayable, :not_searchable])

    t.physdesc(:path=>"did/physdesc[not(dimensions)]", :index_as => [:displayable])
    t.dimensions(:path=>"did/physdesc/dimensions", :index_as => [:displayable])
    t.langmaterial(:path=>"did/langmaterial", :index_as => [:displayable])

    # <odd> nodes
    # These guys depend on what's in <head> so we do some xpathy stuff...
    t.note(:path=>'odd[./head="General note"]/p', :index_as => [:displayable])
    t.accession(:path=>'odd[./head[starts-with(.,"Museum Accession")]]/p', :index_as => [:displayable])
    t.print_run(:path=>'odd[./head[starts-with(.,"Limited")]]/p', :index_as => [:displayable])

  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({"format"          => "Archival Item"})
    solr_doc["parent_unittitles_display"].length > 0 ? solr_doc.merge!({"heading_display" => [ solr_doc["parent_unittitles_display"], self.title.first].join(" >> ")  }) : solr_doc.merge!({"heading_display" => self.title.first  })
    solr_doc.merge!({"ref_s" => self.ref.first})
  end

end