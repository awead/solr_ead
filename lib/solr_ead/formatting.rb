require 'sanitize'

module SolrEad::Formatting

  RENDER_ATTRS =
   {
      "altrender"       => "em",
      "bold"            => "strong",
      "doublequote"     => "em",
      "bolddoublequote" => "strong",
      "bolditalic"      => "strong",
      "boldsinglequote" => "strong",
      "boldsmcaps"      => "strong",
      "boldunderline"   => "strong",
      "italic"          => "em",
      "italics"         => "em",
      "nonproport"      => "em",
      "singlequote"     => "em",
      "smcaps"          => "em",
      "sub"             => "sub",
      "super"           => "sup",
      "underline"       => "em"
   }

  # If you're within the context of an OM::XML::Document, you can just pass the term you want converted and
  # this will get the xml using the term.
  def term_to_html term
    ead_to_html self.send(term).nodeset.to_xml
  end

  # Use this method convert the xml directly
  def ead_to_html xml
    ::Sanitize.clean(transform_render_attributes(xml), :elements => RENDER_ATTRS.values.uniq )
  end

  private

  def transform_render_attributes xml
    ::Sanitize.clean(xml, :transformers => transformer)
  end

  def transformer
    lambda do |env|
      convert_ead_tag_to_html(env[:node])
      {:node_whitelist => [env[:node]]}
    end
  end

  def convert_ead_tag_to_html node
    if RENDER_ATTRS.keys.include? node["render"]
      node.name = RENDER_ATTRS[node["render"]]
      node.remove_attribute "render"
    end
  end

end