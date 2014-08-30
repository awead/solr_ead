#!/usr/bin/env rake
require "rspec/core/rake_task"
Bundler::GemHelper.install_tasks

# load rake tasks in lib/tasks
Dir.glob('lib/tasks/*.rake').each { |r| import r }

RSpec::Core::RakeTask.new(:spec)
task :default => :ci
