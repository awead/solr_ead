require 'om'

class EadDocument

  include OM::XML::Document

  set_terminology do |t|
    t.root(:path=>"ead", :xmlns=>"urn:isbn:1-931666-22-9", :schema=>"http://www.loc.gov/ead/ead.xsd", "xmlns:ns2"=>"http://www.w3.org/1999/xlink", "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance")

    t.ead_id(:path=>"eadid")
    t.archdesc {
      t.did {
        t.unittitle
      }
    }

    # Proxies
    t.ead_collection(:proxy=>[:archdesc, :did, :unittitle])

    # Components
    t.c

  end




end