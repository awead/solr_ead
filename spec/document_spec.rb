require "spec_helper"

describe SolrEad::Document do

  describe "#terminology" do

    let(:ex1) { SolrEad::Document.from_xml(fixture "ARC-0005.xml") }
    let(:ex2) { SolrEad::Document.from_xml(fixture "pp002010.xml") }
    let(:ex3) { SolrEad::Document.from_xml(fixture "ARC-0161.xml") }

    it "should have an id field" do
      expect(ex1.eadid.first).to eq("ARC-0005")
    end

    it "should have a simple title" do
      expect(ex1.title.first).to match "Eddie Cochran Historical Organization Collection"
    end

    it "should have some subject headings" do
      expect(ex1.persname).to  include "Cochran, Eddie, 1938-1960"
      expect(ex1.genreform).to include "Newspapers"
      expect(ex1.subject).to   include "Rockabilly music"
      expect(ex2.corpname).to  include "Tuskegee Normal and Industrial Institute--1880-1940."
      expect(ex2.genreform).to include "Group portraits--1880-1940."
      expect(ex2.geogname).to  include "Washington, D.C."
      expect(ex2.name).to      include "Bell, J.S., Portland, OR"
      expect(ex2.persname).to  include "Johnston, Frances Benjamin, 1864-1952, photographer."
      expect(ex2.subject).to   include "Buildings--1880-1940."
    end

    it "should have scope and contents" do
      expect(ex2.scopecontent.first).to match /^Photographs/
    end

    it "should have one separatedmaterial material note from the archdesc section" do
      expect(ex1.separatedmaterial.first).to match /^Commercially-released publications.*materials are available.$/
    end

    it "should have its xml" do
      expect(ex1.to_xml).to match "<c\s"
      expect(ex2.to_xml).to match "<c01\s"\
    end

    it "should have a bibliography" do
      expect(ex3.bibliography.first).to eq("All Music Guide. Accessed February 4, 2013. http://www.allmusic.com/.")
    end

  end

  describe ".to_solr" do

    let(:ex1) { SolrEad::Document.from_xml(fixture "ARC-0005.xml").to_solr }
    let(:ex2) { SolrEad::Document.from_xml(fixture "pp002010.xml").to_solr }
    let(:ex3) { SolrEad::Document.from_xml(fixture "ARC-0161.xml").to_solr }

    it "should have the appropriate id fields" do
      expect(ex2["id"]).to      eq("http://hdl.loc.gov/loc.pnp/eadpnp.pp002010")
      expect(ex1["id"]).to      eq("ARC-0005")
      expect(ex2[Solrizer.solr_name("ead", :stored_sortable)]).to  eq("http://hdl.loc.gov/loc.pnp/eadpnp.pp002010")
      expect(ex1[Solrizer.solr_name("ead", :stored_sortable)]).to  eq("ARC-0005")
    end

    it "should have faceted terms created from subject headings" do
      expect(ex1[Solrizer.solr_name("persname", :facetable)]).to include "Cochran, Eddie, 1938-1960"
      expect(ex1[Solrizer.solr_name("genreform", :facetable)]).to include "Newspapers"
      expect(ex1[Solrizer.solr_name("subject", :facetable)]).to include "Rockabilly music"
      expect(ex2[Solrizer.solr_name("corpname", :facetable)]).to include "Tuskegee Normal and Industrial Institute--1880-1940."
      expect(ex2[Solrizer.solr_name("genreform", :facetable)]).to include "Group portraits--1880-1940."
      expect(ex2[Solrizer.solr_name("geogname", :facetable)]).to include "Washington, D.C."
      expect(ex2[Solrizer.solr_name("name", :facetable)]).to include "Bell, J.S., Portland, OR"
      expect(ex2[Solrizer.solr_name("persname", :facetable)]).to include "Johnston, Frances Benjamin, 1864-1952, photographer."
      expect(ex2[Solrizer.solr_name("subject", :facetable)]).to include "Buildings--1880-1940."
    end

  end

end
