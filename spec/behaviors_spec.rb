require "spec_helper"

describe SolrEad::Behaviors do

  before :all do
    @not_numbered = fixture "ARC-0005.xml"
    @numbered     = fixture "pp002010.xml"
    class TestClass
      include SolrEad::Behaviors
    end
    @test = TestClass.new
  end

  describe "#components" do

    before :all do
      @non_numbered_nodeset = @test.components(@not_numbered)
      @numbered_nodeset     = @test.components(@numbered)
    end

    it "should return a nodeset" do
      @non_numbered_nodeset.should be_a_kind_of(Nokogiri::XML::NodeSet)
      @non_numbered_nodeset.first.should be_a_kind_of(Nokogiri::XML::Element)
    end

    it "should be able to handle both numbered and non-numbered <c> nodes" do
      @non_numbered_nodeset.count.should == 135
      @numbered_nodeset.count.should == 83
    end
  end

  describe "#prep" do
    it "should return a single component document" do
      part = @test.prep(@numbered_nodeset)
      part.should be_a_kind_of(Nokogiri::XML::Document)
    end
  end

  describe "#component_children?" do

    it "should return true for series-level components" do
      ["series","subseries"].each do |level|
        xml = '<c id="ref42" level="' + level +'"></c>'
        node = Nokogiri::XML(xml)
        @test.component_children?(node.elements.first).should be_true
      end
    end

    it "should return false for item-level components" do
      ["file","item"].each do |level|
        xml = '<c id="ref42" level="' + level +'"></c>'
        node = Nokogiri::XML(xml)
        @test.component_children?(node.elements.first).should be_false
      end
    end

  end

end