require "spec_helper"

describe SolrEad::Indexer do

  before :all do
    @file = fixture "ARC-0005.xml"
  end

  before :each do
    @indexer = SolrEad::Indexer.new
  end

  describe "#create" do
    it "should index a new ead from a file" do
      @indexer.create(@file)
    end
  end

  describe "#update" do
    it "should update an ead from a file" do
      @indexer.update(@file)
    end
  end

  describe "#delete" do
    it "should delete and ead give an id" do
      @indexer.delete("ARC-0005")
    end
  end

end