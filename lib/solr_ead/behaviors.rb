require "sanitize"

module SolrEad::Behaviors

  include SolrEad::Formatting

  # Takes a file as its input and returns a Nokogiri::XML::NodeSet of component <c> nodes
  #
  # It'll make an attempt at substituting numbered component levels (c01..c12) for non-numbered
  # ones.
  # @param [String] `file` pathname to file with EAD data
  def components(file)
    doc = Nokogiri::XML(File.read(file))
    doc.remove_namespaces!
    (1..12).each do |i| # EAD spec provides 12 levels of components
      doc.xpath("//c#{'%02d' % i}").each do |node|
        node.name = 'c'
      end
    end
    doc.xpath('//c')
  end

  # Used in conjunction with #components, this takes a single Nokogiri::XML::Element
  # representing an <c> node from an ead document, and returns a Nokogiri::XML::Document
  # with any child <c> nodes removed.
  # == Example
  # If I input this Nokogiri::XML::Element
  #   <c>
  #     <did>etc</did>
  #     <scopecontent>etc</scopecontent>
  #     <c>etc</c>
  #     <c>etc</c>
  #   </c>
  # Then I should get back the following Nokogiri::XML::Document
  #   <c>
  #     <did>etc</did>
  #     <scopecontent>etc</scopecontent>
  #   </c>
  def prep(node)
    part = Nokogiri::XML(node.to_s)
    part.xpath("/*/c").each { |e| e.remove }
    return part
  end

  # Because the solr documents created from individual components have been removed from
  # the hierarchy of their original ead, we need to be able to reconstruct the order
  # in which they appeared, as well as their location within the hierarchy.
  #
  # This method takes a single Nokogiri::XMl::Node as its argument that represents a
  # single <c> component node, but with all of this parent nodes still attached. From
  # there we can determine all of its parent <c> nodes so that we can correctly
  # reconstruct its placement within the original ead hierarchy.
  #
  # The solr fields returned by this method are:
  #
  # id:: Unique identifier using the id attribute and the <eadid>
  # ead_ssi:: The <eadid> node of the ead. This is so we know which ead this component belongs to.
  # parent_ssi:: The id attribute of the parent <c> node
  # parent_ssm:: Array of all the parent component ids for a given component.
  # parent_unittitles_ssm:: Array of title fields for all the parent components of a given component.
  # parent_unittitles_teim:: Same as above but indexed
  # component_level_ii:: numeric level of the component
  # component_children_bsi:: Boolean field indicating whether or not the component has any child <c> nodes attached to it
  # collection_sim:: Title field of the ead document so we can facet on all components in a collection
  # collection_ssm:: Displayable collection field
  #
  # These fields are used so that we may reconstruct placement of a single component
  # within the hierarchy of the original ead.
  def additional_component_fields(node, addl_fields = Hash.new)

    # Clear or create the cache
    @cache = {}

    p_ids        = parent_id_list(node)
    p_unittitles = parent_unittitle_list(node)

    addl_fields["id"]                                                        = [eadid(node), node.attr("id")].join
    addl_fields[Solrizer.solr_name("ead", :stored_sortable)]                 = eadid(node)
    addl_fields[Solrizer.solr_name("parent", :stored_sortable)]              = node.parent.attr("id") unless node.parent.attr("id").nil?
    addl_fields[Solrizer.solr_name("parent", :displayable)]                  = p_ids
    addl_fields[Solrizer.solr_name("parent_unittitles", :displayable)]       = p_unittitles
    addl_fields[Solrizer.solr_name("parent_unittitles", :searchable)]        = p_unittitles
    addl_fields[Solrizer.solr_name("component_level", :type => :integer)]    = p_ids.length + 1
    addl_fields[Solrizer.solr_name("component_children", :type => :boolean)] = component_children?(node)
    addl_fields[Solrizer.solr_name("collection", :facetable)]                = collection(node)
    addl_fields[Solrizer.solr_name("collection", :displayable)]              = collection(node)
    addl_fields[Solrizer.solr_name("repository", :facetable)]                = repository(node)
    addl_fields[Solrizer.solr_name("repository", :displayable)]              = repository(node)
    addl_fields
  end

  # can these be made to use absolute xpaths?
  def repository(node)
    @cache[:repo] ||= node.xpath("/ead/archdesc/did/repository").text.strip
  end

  def collection(node)
    @cache[:collection] ||= node.xpath("/ead/archdesc/did/unittitle").text
  end

  def eadid(node)
    @cache[:eadid] ||= node.xpath("/ead/eadheader/eadid").text
  end

  # Array of all id attributes from the component's parent <c> nodes, sorted in descending order
  # This is used to reconstruct the order of component documents that should appear above
  # a specific item-level component.
  def parent_id_list(node, results = Array.new)
    while node.parent.name == "c"
      parent = node.parent
      results << parent.attr("id") unless parent.attr("id").nil?
      node = parent
    end
    return results.reverse
  end

  # Array of all unittitle nodes from the component's parent <c> nodes, sort in descending order
  # This is useful if you want to display a list of a component's parent containers in
  # the correct order, ex:
  #   ["Series I", "Subseries a", "Sub-subseries 1"]
  # From there, you can assemble and display as you like.
  def parent_unittitle_list(node, results = ::Array.new)
    while node.parent.name == "c"
      parent = node.parent
      results << get_title(parent)
      node = parent
    end
    results.reverse
  end

  def get_title(node)
    @memtitle ||= Hash.new {|h, node| h[node.object_id] = _get_title(node)}
    @memtitle[node]
  end

  def _get_title(node)
    title = node.at_xpath("./did/unittitle")
    date  = node.at_xpath("./did/unitdate")
    if !title.nil? and !title.content.empty?
      return ead_to_html(title.content)
    elsif !date.nil? and !date.content.empty?
      return ead_to_html(date.content)
    else
      return "[No title available]"
    end
  end

  # @param [Nokogiri::XML::Node] `node`
  # @return true or false for a component with attached <c> child nodes.
  def component_children?(node)
    node.children.any? { |n| n.name == 'c' }
  end

end
