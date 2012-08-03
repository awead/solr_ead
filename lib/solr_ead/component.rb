module SolrEad
class Component

  include OM::XML::Document
  include Solrizer::XML::TerminologyBasedSolrizer

  # Define each term in your ead that you want put into the solr document
  set_terminology do |t|
    t.root(:path=>"c", :index_as => [:not_searchable, :not_displayable])
    t.ref(:path=>"/c/@id")
    t.level(:path=>"/c/@level")

    t.did(:index_as => [:not_searchable, :not_displayable]) {
      t.unittitle
      t.langmaterial {
        t.language(:path=>{ :attribute=>"langcode" })
      }
      t.container
    }
    t.accessrestrict(:index_as => [:not_searchable, :not_displayable]) {
      t.head
      t.p
    }

  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)

  end



end
end