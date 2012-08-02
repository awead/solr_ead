require "spec_helper"

describe "EAD components within a single document" do

  before(:all) do
    file = "ARC-0005.xml"
    raw = File.read(fixture file)
    raw.gsub!(/xmlns=".*"/, '')
    @xml = Nokogiri::XML(raw)
  end

  describe "multiple, multi-level c nodes" do

    it "find all c nodes in the document" do
      debugger
    end

    # TODO: om versus xpath... getting contents of a component easily, like om,
    # but with xpath?  Maybe have a separate terminology just for components?
    #
    # want, maybe:
    # @doc.c_title("ref11")


  end

end