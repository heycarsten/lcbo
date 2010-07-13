require 'bundler'
Bundler.setup

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |t|
  t.pattern    = 'spec/*_spec.rb'
  t.ruby_opts  = %w[--color]
  t.warning    = true
end

gemspec = eval(File.read('lcbo.gemspec'))
# 
# task :build => "#{gemspec.full_name}.gem"
# 
# file "#{gemspec.full_name}.gem" => gemspec.files + ['lcbo.gemspec'] do
#   system "gem build lcbo.gemspec"
#   system "gem install lcbo-#{LCBO::VERSION}.gem"
# end
# 
