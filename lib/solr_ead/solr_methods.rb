module SolrEad::SolrMethods

  def get_field_from_solr(field,id)
    solr_params = Hash.new
    solr_params[:fl]   = "#{field.to_s}"
    solr_params[:q]    = "id:\"#{id.to_s}\""
    solr_params[:qt]   = "standard"
    solr_params[:rows] = 1
    solr_response = Blacklight.solr.find(solr_params)
    doc = solr_response.docs.collect {|doc| SolrDocument.new(doc, solr_response)}
    if doc.first[field.to_sym].nil?
      return nil
    else
      return doc.first[field.to_sym]
    end
  end

  def get_component_docs_from_solr(ead_id,opts={})
    docs = Array.new
    solr_params = Hash.new

    solr_params[:fl]   = "id"
    if opts[:parent_ref]
      solr_params[:q]    = "parent_ref:#{opts[:parent_ref]} AND _query_:\"ead_id:#{ead_id}\""
    else
      solr_params[:q]    = "component_level:#{opts[:level]} AND _query_:\"ead_id:#{ead_id}\""
    end
    solr_params[:sort] = "sort_i asc"
    solr_params[:qt]   = "standard"
    solr_params[:rows] = 1000
    solr_response = Blacklight.solr.find(solr_params)
    list = solr_response.docs.collect {|doc| SolrDocument.new(doc, solr_response)}

    list.each do |doc|
      r, d = get_solr_response_for_doc_id(doc.id)
      docs << d
    end
    return docs
  end


end