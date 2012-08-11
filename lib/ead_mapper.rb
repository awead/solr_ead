class EadMapper < Solrizer::FieldMapper

  id_field 'id'
  index_as :searchable, :default => true do |t|
    t.default :suffix => '_t'
    t.date    :suffix => '_dt'
    t.string  :suffix => '_t'
    t.text    :suffix => '_t'
    t.symbol  :suffix => '_s'
    t.integer :suffix => '_i'
    t.long    :suffix => '_l'
    t.boolean :suffix => '_b'
    t.float   :suffix => '_f'
    t.double  :suffix => '_d'
  end
  index_as :displayable,           :suffix => '_display'
  index_as :facetable,             :suffix => '_facet'
  index_as :sortable,              :suffix => '_sort'
  index_as :unstemmed_searchable,  :suffix => '_unstem_search'
  index_as :string,                :suffix => '_s'
  index_as :z,                     :suffix => '_z'
end