module SolrEad
  class Railtie < Rails::Railtie
    rake_tasks do
      Dir[File.expand_path(File.join(File.dirname(__FILE__),"../../tasks/*.rake"))].each { |ext| load ext }
    end
  end
end
