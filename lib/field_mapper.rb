class FieldMapper < Solrizer::FieldMapper::Default

  id_field 'id'
  index_as :searchablerfoo do |t|
    t.default :suffix => '_s'
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
  index_as :displayablerfoo,          :suffix => '_display'
  index_as :facetablerfoo,            :suffix => '_facet'
  index_as :sortable,             :suffix => '_sort'
  index_as :unstemmed_searchable, :suffix => '_unstem_search'

end