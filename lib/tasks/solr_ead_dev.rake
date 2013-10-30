desc "Travis continuous integration task"
task :ci do
  Rake::Task["jetty:stop"].invoke
  Rake::Task["jetty:clean"].invoke
  Rake::Task["jetty:start"].invoke
  Rake::Task["spec"].invoke
end

namespace :jetty do

  desc "Unpack a clean version of solr-jetty"
  task :clean do
    Jettywrapper.url = "https://github.com/awead/solr-jetty/archive/v1.zip"
    Jettywrapper.clean
  end

  desc "Configure solr-jetty instance"
  task :config do
    `cp solr/schema.xml jetty/solr/blacklight-dev-core/conf/schema.xml`
  end

end