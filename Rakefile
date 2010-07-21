gem 'rspec', '1.3.0'
require 'spec/rake/spectask'

desc 'Run the specs'
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts  = %w[-fs --color]
  #t.warning    = true
end

task :default => :spec

namespace :support do
  desc 'Download all HTML indicated in yaml files'
  task :download do
    require 'yaml'
    require 'pp'
    require 'open-uri'
    product_pages = YAML.load_file('./spec/support/product_pages.yml')
    product_pages.each do |spec|
      html = open(spec[:uri]).read
      File.open("./spec/support/product_pages/#{spec[:file]}", ?w) { |file|
        file.print(html)
      }
    end
  end
end