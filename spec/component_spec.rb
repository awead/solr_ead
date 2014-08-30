require "spec_helper"

describe SolrEad::Component do

  context "with parent components" do

    let(:subject) do
      additional_fields = {
        "id"                                                        => "TEST-0001ref010",
        Solrizer.solr_name("ead", :stored_sortable)                 => "TEST-0001",
        Solrizer.solr_name("parent", :stored_sortable)              => "ref001",
        Solrizer.solr_name("parent", :displayable)                  => ["ref001", "ref002", "ref003"],
        Solrizer.solr_name("parent_unittitles", :displayable)       => ["Series I", "Subseries A", "Subseries 1"],
        Solrizer.solr_name("component_children", :type => :boolean) => FALSE
      }
      SolrEad::Component.from_xml(fixture "component_template.xml").to_solr(additional_fields)
    end

    it "should accept additional fields from a hash" do
      expect(subject["id"]).to eq("TEST-0001ref010")
      expect(subject[Solrizer.solr_name("level", :facetable)]).to include "item"
      expect(subject[Solrizer.solr_name("accessrestrict", :displayable)].first).to match /^This item .* is available.$/
    end

    it "should create fields using type" do
      expect(subject[Solrizer.solr_name("ref", :stored_sortable)]).to eq("ref215")
    end

  end

  context "without parent components" do

    let(:subject) do
      additional_fields = {
        "id"                                                        => "TEST-0001ref010",
        Solrizer.solr_name("ead", :stored_sortable)                 => "TEST-0001",
        Solrizer.solr_name("parent", :stored_sortable)              => "ref001",
        Solrizer.solr_name("parent", :displayable)                  => ["ref001", "ref002", "ref003"],
        Solrizer.solr_name("parent_unittitles", :displayable)       => [],
        Solrizer.solr_name("component_children", :type => :boolean) => FALSE
      }
      SolrEad::Component.from_xml(fixture "component_template.xml").to_solr(additional_fields)
    end
    it "should format heading_display with only one element" do
      expect(subject["id"]).to eq("TEST-0001ref010")
      expect(subject[Solrizer.solr_name("level", :facetable)]).to include "item"
      expect(subject[Solrizer.solr_name("accessrestrict", :displayable)].first).to match /^This item .* is available.$/
    end

  end    

  describe "formatting fields as html" do
    let(:subject) { SolrEad::Component.from_xml(fixture "html_component.xml") }
    it "should format as term as html" do
      expect(subject.term_to_html("scopecontent")).to include "<em>OPAL</em> "
    end
  end

end
