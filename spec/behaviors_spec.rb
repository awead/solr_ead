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

    before :all do
      @true = '
        <c id="ref167" level="file">
          <did>
            <unittitle>Zines</unittitle>
          </did>
          <c id="ref169" level="file">
            <did>
              <unittitle>Contagion</unittitle>
              <container id="cid384011" type="Box" label="Graphic materials">SF2</container>
              <container parent="cid384011" type="Folder">8</container>
              <unitdate>1980-1981</unitdate>
            </did>
          </c>
          <c id="ref171" level="file">
            <did>
              <unittitle>Single issues</unittitle>
              <container id="cid384012" type="Box" label="Graphic materials">SF2</container>
              <container parent="cid384012" type="Folder">9</container>
              <unitdate>1977-1985</unitdate>
            </did>
          </c>
        </c>
      '
      @false = '
        <c id="ref167" level="file">
          <did>
            <unittitle>Zines</unittitle>
          </did>
        </c>
      '
    end


    it "should return true for components that have c nodes below them" do
      node = Nokogiri::XML(@true)
      @test.component_children?(node.elements.first).should be_true
    end

    it "should return false for components that do not have c nodes below them" do
      node = Nokogiri::XML(@false)
      @test.component_children?(node.elements.first).should be_false
    end

  end

end