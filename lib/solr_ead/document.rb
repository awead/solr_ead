module SolrEad
class Document

  include OM::XML::Document
  include SolrEad::TerminologyBasedSolrizer
  include SolrEad::DocumentBehaviors

  # Define each term in your ead that you want put into the solr document
  set_terminology do |t|
    t.root(:path=>"ead",
           :xmlns=>"urn:isbn:1-931666-22-9",
           :schema=>"http://www.loc.gov/ead/ead.xsd",
           "xmlns:ns2"=>"http://www.w3.org/1999/xlink",
           "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
           :index_as => [:not_searchable, :not_displayable])

    t.eadheader(:index_as => [:not_searchable, :not_displayable]) {
      t.eadid
      t.filedesc(:index_as => [:not_searchable, :not_displayable]) {
        t.titlestmt {
          t.titleproper {
            t.num
          }
          t.titleproper_filing(:path=>"titleproper", :attributes=>{ :type => "filing" })
          t.author
        }
        t.publicationstmt(:index_as => [:not_searchable, :not_displayable]) {
          t.publisher
          t.address {
            t.addressline
          }
          t.date
        }
      }
      t.profiledesc(:index_as => [:not_searchable, :not_displayable]) {
        t.creation {
          t.date
        }
        t.langusage
        t.descrules
      }
      t.revisiondesc
    }

    t.archdesc(:index_as => [:not_searchable, :not_displayable]) {
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
        t.unitid
        t.repository {
          t.corpname
        }
        t.langmaterial {
          t.language(:path=>{ :attribute=>"langcode" })
        }
        t.physdesc {
          t.extent
        }
        t.unitdate(:attribute=>{ :type=> :none }) {
          t.normal(:path=>{ :attribute=>"normal" })
        }
        t.unitdate_inclusive(:path=>"unitdate", :attribute=>{ :type=>"inclusive" }) {
          t.normal(:path=>{ :attribute=>"normal" })
        }
        t.unitdate_bulk(:path=>"unitdate", :attribute=>{ :type=>"bulk" }) {
          t.normal(:path=>{ :attribute=>"normal" })
        }
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
    }

    # Proxies
    t.ead_id(:proxy=>[:eadheader, :eadid])


  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({:id => self.ead_id.first})
    solr_doc.merge!({:ead_id_s => self.ead_id.first})
    solr_doc.merge!({:xml_t => self.to_xml})
    return solr_doc
  end

end
end