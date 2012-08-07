# Overrides Solrizer::XML::TerminologyBasedSolrizer in the solrizer gem and
# uses our own custom field mapper defined in EadMapper
module Solrizer::XML::TerminologyBasedSolrizer

  def self.default_field_mapper
    @@default_field_mapper ||= EadMapper.new
  end

end