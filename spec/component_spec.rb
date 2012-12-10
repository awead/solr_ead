require "spec_helper"

describe SolrEad::Component do

  before(:all) do
    file = "component_template.xml"
    @doc = SolrEad::Component.from_xml(fixture file)
  end

  describe "the solr document" do

    describe "for item-level components" do

      before :each do
        additional_fields = {
          "id"                        => "TEST-0001ref010",
          "ead_id"                    => "TEST-0001",
          "parent_id"                 => "ref001",
          "parent_id_s"               => ["ref001", "ref002", "ref003"],
          "parent_unittitles_display" => ["Series I", "Subseries A", "Subseries 1"],
          "component_children_b"      => FALSE
        }
        @solr_doc = @doc.to_solr(additional_fields)
      end

      it "should accept additional fields from a hash" do
        @solr_doc["id"].should == "TEST-0001ref010"
        @solr_doc["level_facet"].should include "item"
        @solr_doc["heading_display"].should == "Series I >> Subseries A >> Subseries 1 >> Internal Revenue Service Form Information Return [RESTRICTED]"
        @solr_doc["accessrestrict_display"].first.should match /^This item .* is available.$/
      end

      it "should create fields using type" do
        @solr_doc["ref_id"].should == "ref215"
      end

    end

    it "should format heading_display with only one element" do
      additional_fields = {
        "id"                        => "TEST-0001ref010",
        "eadid_s"                   => "TEST-0001",
        "parent_id_s"               => "ref001",
        "parent_ids_display"        => ["ref001", "ref002", "ref003"],
        "parent_unittitles_display" => [],
        "component_children_b"      => FALSE
      }
      solr_doc = @doc.to_solr(additional_fields)
      solr_doc["id"].should == "TEST-0001ref010"
      solr_doc["level_facet"].should include "item"
      solr_doc["heading_display"].should == "Internal Revenue Service Form Information Return [RESTRICTED]"
      solr_doc["accessrestrict_display"].first.should match /^This item .* is available.$/
    end       

  end

end