require "spec_helper"

describe SolrEad::Behaviors do

  class TestClass
    include SolrEad::Behaviors
  end

  describe "#components" do

    let(:non_numbered_nodeset)  { TestClass.new.components(fixture("ARC-0005.xml")) }
    let(:numbered_nodeset)      { TestClass.new.components(fixture("pp002010.xml")) }
    let(:messy_nodeset)         { TestClass.new.components(fixture("ead_messy_format.xml")) }

    it "should return a nodeset" do
      expect(non_numbered_nodeset).to be_a_kind_of(Nokogiri::XML::NodeSet)
      expect(non_numbered_nodeset.first).to be_a_kind_of(Nokogiri::XML::Element)
    end

    it "should be able to handle both numbered and non-numbered <c> nodes" do
      expect(non_numbered_nodeset.count).to eq(135)
      expect(numbered_nodeset.count).to eq(83)
    end

    it "should find some components even if ead is messily formatted" do
      expect(messy_nodeset.count).to be > 0
    end

  end

  describe "#prep" do
    let(:subject) { TestClass.new.prep(fixture("pp002010.xml")) }
    it "should return a single component document" do
      expect(subject).to be_a_kind_of(Nokogiri::XML::Document)
    end
  end

  describe '#to_solr_name' do
    subject(:test_obj) { TestClass.new }
    it 'caches the value of Solrizer.solr_name' do
      expect(Solrizer).to receive(:solr_name).and_call_original
      expect(test_obj.to_solr_name('my_test', :facetable)).to eq 'my_test_sim'

      # second time should be cached
      expect(Solrizer).not_to receive(:solr_name)
      expect(test_obj.to_solr_name('my_test', :facetable)).to eq 'my_test_sim'
    end
  end

  describe "#component_children?" do
    let(:true_node) do
      Nokogiri::XML('
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
      ')
    end

    let(:false_node) do
      Nokogiri::XML('
        <c id="ref167" level="file">
          <did>
            <unittitle>Zines</unittitle>
          </did>
        </c>
      ')
    end

    it "should return true for components that have c nodes below them" do
      expect(TestClass.new.component_children?(true_node.elements.first)).to be true
    end

    it "should return false for components that do not have c nodes below them" do
      expect(TestClass.new.component_children?(false_node.elements.first)).to be false
    end

  end

end
