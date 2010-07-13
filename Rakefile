require 'bundler'
Bundler.setup

require 'rspec/core/rake_task'
Rspec::Core::RakeTask.new(:spec)

gemspec = eval(File.read('lcbo.gemspec'))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ['lcbo.gemspec'] do
  system "gem build lcbo.gemspec"
  system "gem install lcbo-#{LCBO::VERSION}.gem"
end
