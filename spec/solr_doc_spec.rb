require "spec_helper"

describe "A solr document created from an example EAD" do

  before(:all) do
    file = "ead_template.xml"
    raw = File.read(fixture file)
    raw.gsub!(/xmlns=".*"/, '')

    @xml = Nokogiri::XML(raw)
  end

  it "should have solr fields created dynamically from its nodes" do


  end

  it "should create solr field names from c level nodes" do
    debugger
    solr_doc = {
      :did_unittitle_t     => ["sample series"],
      :did_unittitle_t     => ["sample series date"],
      :scopecontent_head_t => ["scopecontent heading"],
      :scopecontent_p_t    => ["Sample scopecontent text"],
    }

  end




end