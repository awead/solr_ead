require "spec_helper"

describe SolrEad::Indexer do

  before :all do
    @file = fixture "ARC-0005.xml"
  end

  describe "indexing an ead document into multiple solr documents" do

    before :each do
      @indexer = SolrEad::Indexer.new
    end

    it "should index a new ead from a file" do
      @indexer.create(@file)
      q = @indexer.solr.get 'select', :params => {:q=>'eadid_s:"ARC-0005"', :qt=>'document'}
      q["response"]["numFound"].should == 136
    end


    it "should update an ead from a file" do
      @indexer.update(@file)
      q = @indexer.solr.get 'select', :params => {:q=>'eadid_s:"ARC-0005"', :qt=>'document'}
      q["response"]["numFound"].should == 136
    end

    it "should delete and ead give an id" do
      @indexer.delete("ARC-0005")
      q = @indexer.solr.get 'select', :params => {:q=>'eadid_s:"ARC-0005"', :qt=>'document'}
      q["response"]["numFound"].should == 0
    end

  end

  describe "indexing ead document into one solr document" do

    before :each do
      @simple_indexer = SolrEad::Indexer.new(:simple => true)
    end

    it "should be set to use the simple option" do
      @simple_indexer.opts[:simple].should be_true
    end

    it "should index a new ead from a file as a single solr document" do
      @simple_indexer.create(@file)
      q = @simple_indexer.solr.get 'select', :params => {:q=>'eadid_s:"ARC-0005"', :qt=>'document'}
      q["response"]["numFound"].should == 1
    end

    it "should delete a single ead" do
      @simple_indexer.delete("ARC-0005")
      q = @simple_indexer.solr.get 'select', :params => {:q=>'eadid_s:"ARC-0005"', :qt=>'document'}
      q["response"]["numFound"].should == 0
    end

  end

end