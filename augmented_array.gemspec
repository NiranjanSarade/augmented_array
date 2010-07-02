require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'

spec = Gem::Specification.new do |s| 
  s.name = "augmented_array"
  s.version = "0.0.1"
  s.author = "Niranjan Sarade"
  s.email = "nirusuma@gmail.com"
  s.homepage = "http://github.com/NiranjanSarade/augmented_array" 
  s.platform = Gem::Platform::RUBY
  s.description = "The Ruby Array class is extended with some traversing methods and you will also be able to get and set the 
              individual array elements with indexes as of the indexes were attributes of an array."
  s.summary = "An augmented array class with some useful methods"
  s.files = FileList["{lib}/augmented_array.rb"].to_a
  s.test_files = FileList["{spec}/**/augmented_array_spec.rb"].to_a
  s.has_rdoc = true
  s.rdoc_options << '--title' << 'An Augmented Array' <<
                       '--main' << 'README' <<
                       '--line-numbers'

  s.extra_rdoc_files =FileList["./{README}"].to_a
end

Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_tar = true 
end 