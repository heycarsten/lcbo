require 'bundler/setup'
require 'bundler/gem_tasks'
require 'rake/testtask'

task :default => :spec

desc 'Start an irb console'
task :console do
  system 'bundle exec irb -I lib -r lcbo -r ap'
end

Rake::TestTask.new(:spec) do |t|
  t.libs += %w[lcbo spec]
  t.test_files = FileList['spec/**/*.rb']
  t.verbose = true
end
