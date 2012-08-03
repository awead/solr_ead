require "spec_helper"

describe SolrEad::Document do

  before(:all) do
    file = "ARC-0005.xml"
    @doc      = SolrEad::Document.from_xml(fixture file) { |conf|
      conf.default_xml.noblanks
    }
  end

  describe "the terminology" do

    it "should have different fields for each kind of unitdate" do


    end


  end

  describe "#to_solr" do


    it "should give me a solr document" do
      solr_doc = @doc.to_solr
      solr_doc[:id].should == "ARC-0005"
      solr_doc.keys.each do |key|
        puts "#" * 50
        puts key.to_s
        puts solr_doc[key]
      end
    end



  end

end