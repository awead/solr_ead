require "spec_helper"

describe SolrEad::Component do

  before(:all) do
    file = "component_template.xml"
    @doc = SolrEad::Component.from_xml(fixture file)
  end

  describe "the solr document" do

    it "should accept additional fields from a hash" do
      additional_fields = {
        "id"                        => "TEST-0001:ref010",
        "eadid_s"                   => "TEST-0001",
        "parent_id_s"               => "ref001",
        "parent_ids_display"        => ["ref001", "ref002", "ref003"],
        "parent_unittitles_display" => ["Series I", "Subseries A", "Subseries 1"],
        "component_children_b"      => FALSE
      }
      solr_doc = @doc.to_solr(additional_fields)
      solr_doc["id"].should == "TEST-0001:ref010"
      solr_doc["level_facet"].should include "item"
      solr_doc["heading_display"].should == "Series I >> Subseries A >> Subseries 1 >> Internal Revenue Service Form Information Return [RESTRICTED]"
      solr_doc["accessrestrict_t"].first.should match /^This item .* is available.$/
      solr_doc["accessrestrict_heading_display"].should include "Access Restrictions"

    end

    it "should format heading_display with only one element" do
      additional_fields = {
        "id"                        => "TEST-0001:ref010",
        "eadid_s"                   => "TEST-0001",
        "parent_id_s"               => "ref001",
        "parent_ids_display"        => ["ref001", "ref002", "ref003"],
        "parent_unittitles_display" => [],
        "component_children_b"      => FALSE
      }
      solr_doc = @doc.to_solr(additional_fields)
      solr_doc["id"].should == "TEST-0001:ref010"
      solr_doc["level_facet"].should include "item"
      solr_doc["heading_display"].should == "Internal Revenue Service Form Information Return [RESTRICTED]"
      solr_doc["accessrestrict_t"].first.should match /^This item .* is available.$/
      solr_doc["accessrestrict_heading_display"].should include "Access Restrictions"

    end

  end

end