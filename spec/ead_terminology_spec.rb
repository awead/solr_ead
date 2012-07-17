require "spec_helper"
require "ead_terminology"

describe "EAD terminology" do

  before(:all) do
    file = "ARC-0005.xml"
    @doc      = EadTerminology.from_xml(fixture file) { |conf|
      conf.default_xml.noblanks
    }
    @term = EadTerminology.terminology
  end

  describe "simple terms in our ead document" do

    it "should include an ead id" do
      @doc.term_values(:ead_id).first.should == "ARC-0005"
      @doc.term_values(:ead_collection).first.should == "Eddie Cochran Historical Organization Collection"
    end


  end

end