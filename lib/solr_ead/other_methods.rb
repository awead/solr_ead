module SolrEad::OtherMethods

  def self.ead_id(xml)
    raise "Null ID. This is mostly likely a problem with the ead" if xml.at('/ead/eadheader/eadid').text.empty?
    id = xml.at('/ead/eadheader/eadid').text.gsub(/\.xml/, '')
    id.gsub!(/\./, '-')
    return id
  end

  def self.ead_rake_xml(file)
    raw = File.read(file)
    raw.gsub!(/xmlns=".*"/, '')
    xml = Nokogiri::XML(raw)
  end



  def self.ead_collection(xml)
    xml.xpath("//archdesc/did/unittitle").first.text.gsub("\n",'').gsub(/\s+/, ' ').strip
  end

  def self.ead_xml(document)
    xml_doc = document['xml_display'].first
    xml_doc.gsub!(/xmlns=".*"/, '')
    xml_doc.gsub!('ns2:', '')
    Nokogiri::XML(xml_doc)
  end

  # Note: only handles ranges in the last set of digits
  def self.ead_accession_range(range)

    # Catch incorrectly formatted ranges
    if range.match(";")
      raise "Bad accession range"
    end

    results = Array.new
    first, last = range.split(/-/)
    numbers = range.split(/,/)

    if numbers.length > 1
      numbers.each do |n|

      first, last = n.split(/-/)
        if last
          fparts = first.strip.split(/\./)
          lparts = last.strip.split(/\./)
          (fparts[2]..lparts[2]).each { |n| results << fparts[0] + "." + fparts[1] + "." + n }
        else
          results << n.strip
        end

      end
    elsif last
      fparts = first.strip.split(/\./)
      lparts = last.strip.split(/\./)
      (fparts[2]..lparts[2]).each { |n| results << fparts[0] + "." + fparts[1] + "." + n }
    else
      results << range.strip
    end

    return results

  end

  def self.ead_accessions(node)
    results = Array.new
    node.xpath('//head[contains(., "Museum Accession Number")]').each do | n |
      ead_accession_range(n.next_element.text).each { |a| results << a }
    end

    if results.length > 1
      return results.uniq
    else
      return nil
    end
  end

  def self.get_ead_doc(xml)

    title = xml.at('//eadheader/filedesc/titlestmt/titleproper').text.gsub("\n",'').gsub(/\s+/, ' ').strip
    num = xml.at('//eadheader/filedesc/titlestmt/titleproper/num').text
    title.sub!(num, '(' + num + ')')

    solr_doc = {
      :format         => Rails.configuration.rockhall_config[:ead_format_name],
      :institution_t  => xml.at('//publicationstmt/publisher').text,
      :ead_filename_s => xml.at('//eadheader/eadid').text,
      :id             => Rockhall::EadMethods.ead_id(xml),
      :ead_id         => Rockhall::EadMethods.ead_id(xml),
      :xml_display    => xml.to_xml,
      :text           => xml.text,
    }

    if Rails.configuration.rockhall_config[:ead_display_title_preface].nil?
      solr_doc.merge!({ :heading_display => title })
    else
      solr_doc.merge!({ :heading_display => Rails.configuration.rockhall_config[:ead_display_title_preface] + " " + title })
    end

    Rails.configuration.rockhall_config[:ead_fields].keys.each do | field |
      xpath = Rails.configuration.rockhall_config[:ead_fields][field.to_sym][:xpath]
      result = ead_solr_field(xml,xpath,field)
      unless result.nil?
        solr_doc.merge!(result)
      end
    end

    return solr_doc

  end


  def self.get_component_doc(node,level,counter)
    part, children = ead_prep_component(node,level)
    collection = ead_collection(node)
    title = get_title(part,level)
    parent_titles = ead_parent_unittitles(node,level)
    full_text = part.text + parent_titles.join(" ")

    # Required fields
    doc = {
      :id                     => [ead_id(node), level, node.attr("id")].join(":"),
      :ead_id                 => ead_id(node),
      :component_level        => level,
      :component_children_b   => children,
      :ref                    => node.attr("id"),
      :sort_i                 => counter,
      :parent_ref             => node.parent.attr("id"),
      :parent_ref_list        => ead_parent_refs(node,level),
      :parent_unittitle_list  => parent_titles,
      :collection_display     => collection,
      :collection_facet       => collection,
      :text                   => full_text,
      :title_display          => title
    }

    # Optional fields take from Rails.configuration.rockhall_config
    Rails.configuration.rockhall_config[:component_fields].keys.each do |field|
      xpath = "//c0#{level}/#{Rails.configuration.rockhall_config[:component_fields][field.to_sym][:xpath]}"
      result = ead_solr_field(part,xpath,field, { :component => TRUE })
      unless result.nil?
        doc.merge!(result)
      end
      if Rails.configuration.rockhall_config[:component_fields][field.to_sym][:is_xpath]
        xpath = "//c0#{level}/#{Rails.configuration.rockhall_config[:component_fields][field.to_sym][:label]}"
        label = field.to_s + "_label"
        result = ead_solr_field(part,xpath,label, { :component => TRUE })
        unless result.nil?
          doc.merge!(result)
        end
      end
    end

    # Location field gets special treatment
    location = ead_location(part)
    unless location.nil?
      doc.merge!({ :location_display => location })
    end

    # Formulate special heading display, if configured
    if Rails.configuration.rockhall_config[:ead_component_title_separator].nil?
      doc.merge!({ :heading_display => title })
    else
      elements = Array.new
      elements << collection
      elements << ead_parent_unittitles(node,level) unless ead_parent_unittitles(node,level).length < 1
      elements << title
      doc.merge!({ :heading_display => elements.join(Rails.configuration.rockhall_config[:ead_component_title_separator]) })
    end

    # Components with containers, representing individual items,
    # get faceted with their material type and a general format type
	# Otherwise, they are marked as a series and supressed from search results.
    material = ead_material(part)
    if material.nil?
      doc.merge!({ :series_b => TRUE })
    else
      doc.merge!({ :material_facet => material })
	    doc.merge!({ :format => Rails.configuration.rockhall_config[:ead_component_name] })
    end

    # index accession numbers and ranges
    accessions = ead_accessions(part)
    unless accessions.nil?
      doc.merge!({ :accession_t => accessions })
    end

    return doc
  end

  def ead_solr_field(part,xpath,field,opts={})
    opts[:component].nil? ? field_class = "ead_fields" : field_class = "component_fields"
    unless part.xpath(xpath).text.empty?
      lines = Array.new
      part.xpath(xpath).each do |line|
        unless line.text.empty?
          if Rails.configuration.rockhall_config[field_class.to_sym][field.to_sym].nil?
            lines << line.text
          else
            if Rails.configuration.rockhall_config[field_class.to_sym][field.to_sym][:formatted]
              lines << ead_clean_xml(line.to_xml)
            else
              lines << line.text
            end
          end
        end
      end
      { field.to_sym => lines }
    end
  end


  def ead_location(node)
    r = Array.new
    node.xpath("//did/container").each do |container|
      if container.attr("label").nil?
        r << container.attr("type") + ": " + container.text
      else
        if container.attr("label").match("Copy")
          r << container.attr("label") + " - " + container.attr("type") + ": " + container.text
        else
          r << container.attr("type") + ": " + container.text
        end
      end
    end
   return r.join(", ")
  end

  def ead_material(node)
    r = Array.new
    values = node.search("container[@label]")
    values.each do |v|
      r << v.attr(:label)
    end
    return r
  end

  def ead_prep_component(node,level)
    part = Nokogiri::XML(node.to_xml)
    next_level = level.to_i + 1
    if part.search("//c0#{next_level}").count > 0
      part.search("//c0#{next_level}").each { |subpart| subpart.remove }
      return part, "true"
    else
      return part, "false"
    end
  end

  def ead_parent_refs(node,level)
    results = Array.new
    while level > 0
      level = level - 1
      parent = node.parent
      results << parent.attr("id") unless parent.attr("id").nil?
      node = parent
    end
    return results.reverse
  end

  def ead_parent_unittitles(node,level)
    results = Array.new
    # decrement now to avoid looking for "c00" nodes
    level = level - 1
    while level > 0
      parent = node.parent
      part = Nokogiri::XML(parent.to_xml)
      results << get_title(part,level)
      node = parent
      level = level - 1
    end
    return results.reverse
  end

  def ead_clean_xml(string)
    string.gsub!(/<title/,"<span")
    string.gsub!(/<\/title/,"</span")
    string.gsub!(/render=/,"class=")
    sanitize = Sanitize.clean(string, :elements => ['span'], :attributes => {'span' => ['class']})
    sanitize.gsub("\n",'').gsub(/\s+/, ' ').strip
  end

  def get_title(xml,level)
    title = xml.at("//c0#{level}/did/unittitle")
    date  = xml.at("//c0#{level}/did/unitdate")
    if !title.nil? and !title.content.empty?
      return ead_clean_xml(title.content)
    elsif !date.nil? and !date.content.empty?
      return ead_clean_xml(date.content)
    else
      return "[No title available]"
    end
  end


end