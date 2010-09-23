gem 'rspec', '1.3.0'
require 'rubygems/specification' unless defined?(Gem::Specification)
require 'spec/rake/spectask'
require 'rake/gempackagetask'

task :default => :spec

def gemspec
  @gemspec ||= begin
    Gem::Specification.load(File.expand_path('lcbo.gemspec'))
  end
end

desc 'Start an irb console'
task :console do
  system 'irb -I lib -r lcbo'
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

Rake::GemPackageTask.new(gemspec) do |pkg|
  pkg.gem_spec = gemspec
end
task :gem => :gemspec
task :package => :gemspec

desc 'Run the specs'
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts  = %w[-fs --color]
end

desc 'Download all HTML indicated in YAML assertion files'
task :download_support do
  require 'yaml'
  require 'open-uri'
  product_pages = YAML.load_file('./spec/support/product_pages.yml')
  product_pages.each do |spec|
    html = open(spec[:uri]).read
    File.open("./spec/support/product_pages/#{spec[:file]}", ?w) { |file|
      file.print(html)
    }
  end
end
