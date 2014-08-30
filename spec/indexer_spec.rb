require "spec_helper"

describe SolrEad::Indexer do

  let(:file) { fixture "ARC-0005.xml" }

  describe "indexing an ead document into multiple solr documents" do

    let(:indexer) { SolrEad::Indexer.new }

    it "should index a new ead from a file" do
      indexer.create(file)
      q = indexer.solr.get 'select', :params => {:q=>Solrizer.solr_name("ead", :stored_sortable)+':"ARC-0005"', :qt=>'document'}
      expect(q["response"]["numFound"]).to eq(136)
    end

    it "should update an ead from a file" do
      indexer.update(file)
      q = indexer.solr.get 'select', :params => {:q=>Solrizer.solr_name("ead", :stored_sortable)+':"ARC-0005"', :qt=>'document'}
      expect(q["response"]["numFound"]).to eq(136)
    end

    it "should delete and ead give an id" do
      indexer.delete("ARC-0005")
      q = indexer.solr.get 'select', :params => {:q=>Solrizer.solr_name("ead", :stored_sortable)+':"ARC-0005"', :qt=>'document'}
      expect(q["response"]["numFound"]).to eq(0)
    end

  end

  describe "indexing ead document into one solr document" do

    let(:indexer) { SolrEad::Indexer.new(:simple => true) }

    it "should be set to use the simple option" do
      expect(indexer.options[:simple]).to be true
    end

    it "should index a new ead from a file as a single solr document" do
      indexer.create(file)
      q = indexer.solr.get 'select', :params => {:q=>Solrizer.solr_name("ead", :stored_sortable)+':"ARC-0005"', :qt=>'document'}
      expect(q["response"]["numFound"]).to eq(1)
    end

    it "should delete a single ead" do
      indexer.delete("ARC-0005")
      q = indexer.solr.get 'select', :params => {:q=>Solrizer.solr_name("ead", :stored_sortable)+':"ARC-0005"', :qt=>'document'}
      expect(q["response"]["numFound"]).to eq(0)
    end

  end

  describe "specifying custom om definitions" do

    class CustomDocument < SolrEad::Document
      include OM::XML::Document
      include OM::XML::TerminologyBasedSolrizer
      include SolrEad::OmBehaviors
      set_terminology do |t|
        t.root(:path=>"ead", :index_as => [:not_searchable])
        t.title
        t.eadid
        t.title_num
      end
    end

    class CustomComponent < SolrEad::Component
      include OM::XML::Document
      include OM::XML::TerminologyBasedSolrizer
      set_terminology do |t|
        t.root(:path=>"c", :index_as => [:not_searchable, :not_displayable])
        t.ref(:path=>"/c/@id")
        t.level(:path=>"/c/@level", :index_as => [:facetable])
        t.title(:path=>"unittitle", :attributes=>{ :type => :none }, :index_as=>[:searchable, :displayable])
      end
    end

    it "should raise an error if you use an undefined class" do
      expect {SolrEad::Indexer.new(:document => BogusClass)}.to raise_error NameError
    end

    it "should accept a document definition" do
      indexer = SolrEad::Indexer.new(:document => CustomDocument)
      indexer.create(file)
    end

    it "should accept a component definition" do
      indexer = SolrEad::Indexer.new(:component => CustomComponent)
      indexer.create(file)
    end

    it "should accept a simple custom document definition" do
      indexer = SolrEad::Indexer.new(:document => CustomDocument, :stored_sortable=>true)
      indexer.create(file)
    end

    it "should accept both custom definitions and components" do
      indexer = SolrEad::Indexer.new(:document => CustomDocument, :component => CustomComponent)
      indexer.create(file)
    end

  end

end
