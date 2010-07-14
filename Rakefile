require 'spec/rake/spectask'

desc 'Run the specs'
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts  = %w[-fs --color]
  #t.warning    = true
end

task :default => :spec
