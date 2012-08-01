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




end