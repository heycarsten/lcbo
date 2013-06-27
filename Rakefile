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
    FileList['spec/saq_spec.rb']
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


namespace :scrape do
  $:.unshift(Dir.pwd+"/lib")
  require 'lcbo'
  require 'bcl'
  require 'saq'

  GROUPS_OF = 10


  desc 'import bcl products'
  task :bcl_products do

    each_products(BCL) do |product_hash|
      # Make call to winealign api endpoint
      puts product_hash
    end
  end


  desc 'import saq products'
  task :saq_products do
    each_products(SAQ) do |product_hash|
      # Make call to winealign api endpoint
      puts product_hash
    end
  end


  def each_products(scraper_module)
    each_products_api_id(scraper_module) do |api_id|
      yield scraper_module::ProductPage.process(:id => api_id).as_hash
    end
  end

  def each_products_api_id(scraper_module)
    number_of_products =  scraper_module::ProductListPage.process(beginIndex:0).as_hash[:total_products]
    puts "#{number_of_products} - #{scraper_module} products found"

    (number_of_products.to_f / GROUPS_OF).ceil.times do |page|
      scraper_module::ProductListPage.process(beginIndex:GROUPS_OF*page).product_ids.each do |api_id|
        yield api_id

        puts "\n#{number_of_products -= 1} - #{scraper_module} products remain"
        sleep(rand(3)+1) #sleep random 1-3 seconds
      end
    end
  end

  def each_inventory(scraper_module)
    each_products_api_id(scraper_module) do |api_id|
      yield scraper_module::InventoryPage.process(:product_id => api_id).as_hash
    end
  end


  desc 'import BCL inventory'
  task :bcl_inventory do
    each_inventory(BCL) do |inventory_hash|
      # Make call to winealign api endpoint
      puts inventory_hash
    end
  end


  desc 'import SAQ inventory'
  task :saq_inventory do
    each_inventory(SAQ) do |inventory_hash|
      # Make call to winealign api endpoint
      puts inventory_hash
    end
  end
end
