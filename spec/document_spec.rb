require "spec_helper"

describe SolrEad::Document do

  before(:all) do
    file = "ARC-0005.xml"
    file2 = "pp002010.xml"
    @doc      = SolrEad::Document.from_xml(fixture file) { |conf|
      conf.default_xml.noblanks
    }
    @doc2      = SolrEad::Document.from_xml(fixture file2) { |conf|
      conf.default_xml.noblanks
    }
  end

  describe "the terminology" do

  end

  describe "#to_solr" do

    it "should give me a solr document" do
      solr_doc = @doc.to_solr
      solr_doc2 = @doc2.to_solr
      solr_doc[:id].should == "ARC-0005"
      solr_doc[:xml_t].should match "<c\s"
      solr_doc2[:xml_t].should match "<c01\s"
    end

  end

end