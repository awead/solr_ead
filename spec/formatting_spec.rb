require 'spec_helper'

describe SolrEad::Formatting do

  let(:subject) do
    class SampleClass
      include SolrEad::Formatting
    end
    return SampleClass.new
  end

  describe "#ead_to_html" do
    
    it "should convert ead markup to html" do
      xml = 'This is some text with <title render="italics">italics</title> included in it.'
      expect(subject.ead_to_html(xml)).to eq('This is some text with <em>italics</em> included in it.')
    end

    it "should remove other tags" do
      xml = 'Blah blah <title render="italics">italics</title> blah <span>blah</span> <title render="bold">italics</title>'
      expect(subject.ead_to_html(xml)).to eq('Blah blah <em>italics</em> blah blah <strong>italics</strong>')      
    end
  end

end
