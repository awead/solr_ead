module SolrEad
class Document

  include OM::XML::Document
  include Solrizer::XML::TerminologyBasedSolrizer

  # Define each term in your ead that you want put into the solr document
  set_terminology do |t|
    t.root(:path=>"ead", :xmlns=>"urn:isbn:1-931666-22-9", :schema=>"http://www.loc.gov/ead/ead.xsd", "xmlns:ns2"=>"http://www.w3.org/1999/xlink", "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance")

    t.eadheader {
      t.eadid
      t.filedesc {
        t.titlestmt {
          t.titleproper {
            t.num
          }
          t.titleproper_filing(:path=>"titleproper", :attributes=>{ :type => "filing" })
          t.author
        }
        t.publicationstmt {
          t.publisher
          t.address {
            t.addressline
          }
          t.date
        }
      }
      t.profiledesc {
        t.creation {
          t.date
        }
        t.langusage
        t.descrules
      }
      t.revisiondesc
    }

    t.archdesc {
      t.did {
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
      t.separatedmaterial {
        t.head
        t.p
      }
      t.relatedmaterial {
        t.head
        t.p
      }
      t.prefercite {
        t.head
        t.p
      }
      t.custodhist {
        t.head
        t.p
      }
      t.userestrict {
        t.head
        t.p
      }
      t.accessrestrict {
        t.head
        t.p
      }
      t.processinfo {
        t.head
        t.p
      }
      t.controlaccess {
        t.corpname(:index_as=>[:facetable])
        t.famname(:index_as=>[:facetable])
        t.genreform(:index_as=>[:facetable])
        t.geogname(:index_as=>[:facetable])
        t.name(:index_as=>[:facetable])
        t.persname(:index_as=>[:facetable])
        t.subject(:index_as=>[:facetable])
      }
    }

    # Proxies
    t.ead_id(:proxy=>[:eadheader, :eadid])
    #t.collection(:proxy=>[:archdesc, :did, :unittitle])


  end

  def to_solr(solr_doc = Hash.new)
    super(solr_doc)
    solr_doc.merge!({:id => self.ead_id.first})
    return solr_doc
  end

end
end