require "spec_helper"

describe SolrEad::Component do

  context "with parent components" do
    let(:xml_data) { fixture "component_template.xml" }
    let(:additional_fields) { {
            "id"                                                        => "TEST-0001ref010",
            Solrizer.solr_name("ead", :stored_sortable)                 => "TEST-0001",
            Solrizer.solr_name("parent", :stored_sortable)              => "ref001",
            Solrizer.solr_name("parent", :displayable)                  => ["ref001", "ref002", "ref003"],
            Solrizer.solr_name("parent_unittitles", :displayable)       => ["Series I", "Subseries A", "Subseries 1"],
            Solrizer.solr_name("component_children", :type => :boolean) => false
    } }

    let(:subject) do
      SolrEad::Component.from_xml(xml_data).to_solr(additional_fields)
    end

    it "should accept additional fields from a hash" do
      expect(subject["id"]).to eq("TEST-0001ref010")
      expect(subject[Solrizer.solr_name("level", :facetable)]).to include "item"
      expect(subject[Solrizer.solr_name("accessrestrict", :displayable)].first).to match /^This item .* is available.$/
    end

    it "should create fields using type" do
      expect(subject[Solrizer.solr_name("ref", :stored_sortable)]).to eq("ref215")
    end

    context '#refs' do
      context 'missing ones' do
        let(:xml_data) { fixture("component_template.xml").read.gsub(/id=".*"\s/, '') }
        it do
          expect(subject[Solrizer.solr_name("ref", :stored_sortable)]).to be_nil
        end
      end
      context 'blank ones' do
        let(:xml_data) { fixture("component_template.xml").read.gsub(/id=".*"\s/, 'id=" "') }
        it do
          expect(subject[Solrizer.solr_name("ref", :stored_sortable)]).to be_nil
        end
      end
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
        Solrizer.solr_name("component_children", :type => :boolean) => false
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
