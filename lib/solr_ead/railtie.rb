module SolrEad
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.join(File.dirname(__FILE__),"../tasks/solr_ead.rake")
    end
  end
end