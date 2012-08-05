require "spec_helper"

describe SolrEad::ComponentBehaviors do

  before :all do
    file = "ARC-0005.xml"
    @xml = fixture file
  end

  before :each do
    class TestClass
      include SolrEad::ComponentBehaviors
    end
    @test = TestClass.new
  end

  describe "#components" do
    it "should return at array of Nokogiri nodes" do
      nodeset = @test.components(@xml)
      nodeset.should be_a_kind_of(Nokogiri::XML::NodeSet)
      array.first.should be_a_kind_of(Nokogiri::XML::Element)
    end
  end

  describe "#prep" do
    it "should return a single component document" do
      part = @test.prep(@test.components(@xml).first)
      part.should be_a_kind_of(Nokogiri::XML::Document)
    end

  end

end