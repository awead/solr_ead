require 'jettywrapper'
Jettywrapper.url = "https://github.com/awead/solr-jetty/archive/v1.zip"

desc "Travis continuous integration task"
task :ci do
  Rake::Task["jetty:clean"].invoke
  Rake::Task["jetty:start"].invoke
  Rake::Task["spec"].invoke
end
