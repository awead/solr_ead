module SolrEad::TerminologyBasedSolrizer

  include Solrizer::XML::TerminologyBasedSolrizer

  def self.default_field_mapper
    @@default_field_mapper ||= EadMapper.new
  end

end