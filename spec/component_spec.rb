require "spec_helper"

describe SolrEad::Component do

  before(:all) do
    file = "component_template.xml"
    @doc = SolrEad::Component.from_xml(fixture file)
  end

  describe "the terminology" do

    it "should have some terms" do

    end

  end

  describe "the solr document" do

    it "should have some fields" do
      solr_doc = @doc.to_solr
      solr_doc.keys.each do |key|
        puts "#" * 50
        puts key.to_s
        puts solr_doc[key]
      end

    end



  end

end