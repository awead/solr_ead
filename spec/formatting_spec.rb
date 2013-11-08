require 'spec_helper'

describe SolrEad::Formatting do

  before :all do
    class SampleClass
      include SolrEad::Formatting
    end
    @sample = SampleClass.new
  end

  describe "#ead_to_html" do
    
    it "should convert ead markup to html" do
      xml = 'This is some text with <title render="italics">italics</title> included in it.'
      @sample.ead_to_html(xml).should == 'This is some text with <em>italics</em> included in it.'
    end

    it "should remove other tags" do
      xml = 'Blah blah <title render="italics">italics</title> blah <span>blah</span> <title render="bold">italics</title>'
      @sample.ead_to_html(xml).should == 'Blah blah <em>italics</em> blah blah <strong>italics</strong>'      
    end
  end


end