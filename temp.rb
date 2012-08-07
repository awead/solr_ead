 t.eadheader(:index_as => [:not_searchable, :not_displayable]) {
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
