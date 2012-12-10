class EadMapper < Solrizer::FieldMapper
  id_field 'id'
  index_as :displayable, :suffix => '_display'
  index_as :searchable,  :suffix => '_t'
  index_as :unstemmed,   :suffix => '_unstem_search'
  index_as :string,      :suffix => '_s'
  index_as :date,        :suffix => '_dt'
  index_as :integer,     :suffix => '_i'
  index_as :boolean,     :suffix => '_b'
  index_as :facetable,   :suffix => '_facet'
  index_as :sortable,    :suffix => '_sort'
  index_as :keyed,       :suffix => '_id'
end