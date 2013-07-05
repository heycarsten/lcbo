require 'rubygems/specification' unless defined?(Gem::Specification)
require 'rubygems/package_task'
require 'rake/testtask'

def gemspec
  @gemspec ||= begin
    Gem::Specification.load(File.expand_path('lcbo.gemspec'))
  end
end

task :default => :spec

desc 'Start an irb console'
task :console do
  system 'irb -I lib -r lcbo -r bcl -r saq'
end

desc 'Validates the gemspec'
task :gemspec do
  gemspec.validate
end

desc 'Displays the current version'
task :version do
  puts "Current version: #{gemspec.version}"
end

desc 'Installs the gem locally'
task :install => :package do
  sh "gem install pkg/#{gemspec.name}-#{gemspec.version}"
end

desc 'Release the gem'
task :release => :package do
  sh "gem push pkg/#{gemspec.name}-#{gemspec.version}.gem"
end

Gem::PackageTask.new(gemspec) do |pkg|
  pkg.gem_spec = gemspec
end
task :gem => :gemspec
task :package => :gemspec

Rake::TestTask.new(:spec) do |t|
  t.libs += %w[lcbo spec]
  # t.test_files = FileList['spec/**/*.rb']
  # t.test_files = FileList[ENV['SPEC'] || 'spec/**/*.rb']
  t.test_files = [
    FileList['spec/lcbo_spec.rb'],
    FileList['spec/bcl_spec.rb'],
    FileList['spec/saq_spec.rb'],
  ]
  t.verbose = true
end

# desc 'Download all HTML indicated in YAML assertion files'
# task :download_support do
#   require 'yaml'
#   require 'open-uri'
#   pages = YAML.load_file('./spec/support/pages.yml')
#   pages.each do |type, uris|
#     uris.each_with_index do |uri, i|
#       html = open(uri).read
#       File.open("./spec/support/#{type}/#{i}.html", ?w) { |file|
#         file.print(html)
#       }
#     end
#   end
# end

