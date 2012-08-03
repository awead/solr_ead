require "sanitize"

module SolrEad::ComponentBehaviors

  def components(file)
    raw = File.read(file)
    raw.gsub!(/xmlns=".*"/, '')
    xml = Nokogiri::XML(raw)
    xml.xpath("//c")
  end

  def prep(node)
    part = Nokogiri::XML(node.to_xml)
    part.elements.each do |e|
      e.remove if e.name == "c"
    end
    return part
  end

  def additional_component_fields(node)
    return {}
  end

  def parent_refs(node)
    results = Array.new
    #if node.respond_to?("parent")
      while node.parent.name == "c"
        parent = node.parent
        results << parent.attr("id") unless parent.attr("id").nil?
        node = parent
      end
    #end
    return results.reverse
  end

  def parent_unittitles(node)
    results = Array.new
    while node.parent.name == "c"
      parent = node.parent
      part = Nokogiri::XML(parent.to_xml)
      results << get_title(part)
      node = parent
    end
    return results.reverse
  end

  def get_title(xml)
    title = xml.at("/c/did/unittitle")
    date  = xml.at("/c/did/unitdate")
    if !title.nil? and !title.content.empty?
      return ead_clean_xml(title.content)
    elsif !date.nil? and !date.content.empty?
      return ead_clean_xml(date.content)
    else
      return "[No title available]"
    end
  end

  def ead_clean_xml(string)
    string.gsub!(/<title/,"<span")
    string.gsub!(/<\/title/,"</span")
    string.gsub!(/render=/,"class=")
    sanitize = Sanitize.clean(string, :elements => ['span'], :attributes => {'span' => ['class']})
    sanitize.gsub("\n",'').gsub(/\s+/, ' ').strip
  end



end