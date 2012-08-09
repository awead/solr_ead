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
      @simple_indexer.options[:simple].should be_true
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

  describe "specifying custom om definitions" do

    before :all do
      class CustomDocument < SolrEad::Document
        include OM::XML::Document
        include Solrizer::XML::TerminologyBasedSolrizer
        include SolrEad::OmBehaviors
        set_terminology do |t|
          t.root(:path=>"ead", :index_as => [:not_searchable])
          t.title
          t.eadid
        end
      end

      class CustomComponent < SolrEad::Component
        include OM::XML::Document
        include Solrizer::XML::TerminologyBasedSolrizer
        set_terminology do |t|
          t.root(:path=>"c", :index_as => [:not_searchable, :not_displayable])
          t.ref(:path=>"/c/@id")
          t.level(:path=>"/c/@level", :index_as => [:facetable])
          t.title(:path=>"unittitle", :attributes=>{ :type => :none }, :index_as=>[:searchable, :displayable])
        end
      end
    end

    it "should raise an error if you use an undefined class" do
      indexer = SolrEad::Indexer.new(:document => "BogusClass")
      lambda {indexer.create(@file)}.should raise_error NameError
    end

    it "should accept a document definition" do
      indexer = SolrEad::Indexer.new(:document => "CustomDocument")
      indexer.create(@file)
    end

    it "should accept a component definition" do
      indexer = SolrEad::Indexer.new(:component => "CustomComponent")
      indexer.create(@file)
    end

    it "should accept a simple custom document definition" do
      indexer = SolrEad::Indexer.new(:document => "CustomDocument", :simple=>true)
      indexer.create(@file)
    end

    it "should accept both custom definitions and components" do
      indexer = SolrEad::Indexer.new(:document => "CustomDocument", :component => "CustomComponent")
      indexer.create(@file)
    end

  end

end