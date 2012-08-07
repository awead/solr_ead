module SolrEad
class Component

  include OM::XML::Document
  include Solrizer::XML::TerminologyBasedSolrizer

  # Define each term in your ead that you want put into the solr document
  set_terminology do |t|
    t.root(:path=>"c", :index_as => [:not_searchable, :not_displayable])
    t.ref(:path=>"/c/@id")
    t.level(:path=>"/c/@level", :index_as => [:facetable])
    t.accessrestrict(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }
    t.accruals(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }
    t.acqinfo(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }
    t.altformavail(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }
    t.appraisal(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }
    t.arrangement(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }
    t.bibliography(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
      t.bibref
    }
    t.controlaccess(:index_as => [:not_searchable, :not_displayable]) {
      t.corpname(:index_as=>[:facetable])
      t.famname(:index_as=>[:facetable])
      t.genreform(:index_as=>[:facetable])
      t.geogname(:index_as=>[:facetable])
      t.name(:index_as=>[:facetable])
      t.persname(:index_as=>[:facetable])
      t.subject(:index_as=>[:facetable])
    }
    t.custodhist(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }
    t.did(:index_as => [:not_searchable, :not_displayable]) {
      t.unittitle
      t.langmaterial {
        t.language(:path=>{ :attribute=>"langcode" })
      }
      t.container
    }
    t.fileplan(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }
    t.note(:index_as => [:not_searchable, :not_displayable]) {
      t.p
    }
    t.odd(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }
    t.originalsloc(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }
    t.phystech(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }
    t.prefercite(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }
    t.processinfo(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }
    t.relatedmaterial(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }
    t.separatedmaterial(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }
    t.scopecontent(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }
    t.userestrict(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }
  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({:xml_t => self.to_xml})
  end

end
end