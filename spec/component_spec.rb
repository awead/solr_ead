require "spec_helper"

describe SolrEad::Component do

  describe "the solr document" do

    before :all do
      file = "component_template.xml"
      @doc = SolrEad::Component.from_xml(fixture file)
    end

    describe "for item-level components" do

      before :each do
        additional_fields = {
          "id" => "TEST-0001ref010",
          Solrizer.solr_name("ead", :stored_sortable)                 => "TEST-0001",
          Solrizer.solr_name("parent", :stored_sortable)              => "ref001",
          Solrizer.solr_name("parent", :displayable)                  => ["ref001", "ref002", "ref003"],
          Solrizer.solr_name("parent_unittitles", :displayable)       => ["Series I", "Subseries A", "Subseries 1"],
          Solrizer.solr_name("component_children", :type => :boolean) => FALSE
        }
        @solr_doc = @doc.to_solr(additional_fields)
      end

      it "should accept additional fields from a hash" do
        @solr_doc["id"].should == "TEST-0001ref010"
        @solr_doc[Solrizer.solr_name("level", :facetable)].should include "item"
        @solr_doc[Solrizer.solr_name("accessrestrict", :displayable)].first.should match /^This item .* is available.$/
      end

      it "should create fields using type" do
        @solr_doc[Solrizer.solr_name("ref", :stored_sortable)].should == "ref215"
      end

    end

    it "should format heading_display with only one element" do
      additional_fields = {
        "id"                                                        => "TEST-0001ref010",
        Solrizer.solr_name("ead", :stored_sortable)                 => "TEST-0001",
        Solrizer.solr_name("parent", :stored_sortable)              => "ref001",
        Solrizer.solr_name("parent", :displayable)                  => ["ref001", "ref002", "ref003"],
        Solrizer.solr_name("parent_unittitles", :displayable)       => [],
        Solrizer.solr_name("component_children", :type => :boolean) => FALSE
      }
      solr_doc = @doc.to_solr(additional_fields)
      solr_doc["id"].should == "TEST-0001ref010"
      solr_doc[Solrizer.solr_name("level", :facetable)].should include "item"
      solr_doc[Solrizer.solr_name("accessrestrict", :displayable)].first.should match /^This item .* is available.$/
    end       

  end

  describe "formatting fields as html" do

    before :all do
      file = "html_component.xml"
      @sample = SolrEad::Component.from_xml(fixture file)
    end

    it "should format as term as html" do
      @sample.term_to_html("scopecontent").should include "<em>OPAL</em> "
    end

  end

end