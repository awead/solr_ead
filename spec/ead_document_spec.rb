require "spec_helper"
require "ead_document"

describe "An EAD document" do

  before(:all) do
    file = "ARC-0005.xml"
    @doc      = EadDocument.from_xml(fixture file) { |conf|
      conf.default_xml.noblanks
    }
    @term = EadDocument.terminology
  end

  describe "non-multivalued terms" do

    it "should include an ead id" do
      @doc.term_values(:ead_id).first.should == "ARC-0005"
      @doc.term_values(:ead_collection).first.should == "Eddie Cochran Historical Organization Collection"
    end


  end

end