# coding: utf-8
# $:.push File.expand_path("../lib", __FILE__)                                # FROM ActiveTriples gemspec file
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ld4l/virtual_collection_rdf/version'

Gem::Specification.new do |spec|
  spec.name          = "ld4l-virtual_collection_rdf"
  spec.version       = Ld4l::VirtualCollectionRdf::VERSION
  spec.authors       = ["E. Lynette Rayle"]
  spec.email         = ["elr37@cornell.edu"]
  spec.platform      = Gem::Platform::RUBY                                    # FROM ActiveTriples gemspec file
  spec.summary       = %q{VirtualCollection RDF models.}
  spec.description   = %q{LD4L Virtual Collection RDF provides tools for modeling a Virtual Collection with items and persisting to a triplestore.}
  spec.homepage      = "https://github.com/ld4l/virtual_collection_rdf"
  spec.license       = "APACHE2"
  spec.required_ruby_version     = '>= 1.9.3'                                 # FROM ActiveTriples gemspec file

  spec.files         = `git ls-files -z`.split("\x0")
  # spec.files         = `git ls-files`.split("\n")                           # FROM ActiveTriples gemspec file
  # spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }  # NOT IN ActiveTriples gemspec file
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  # spec.test_files    = `git ls-files -- {spec}/*`.split("\n")               # FROM ActiveTriples gemspec file
  # spec.require_paths = ["lib"]                                              # NOT IN ActiveTriples gemspec file

  spec.add_dependency('rdf', '~> 1.1')
  spec.add_dependency('active-triples', '~> 0.2')

  # spec.add_development_dependency "bundler", "~> 1.6"                       # NOT IN ActiveTriples gemspec file
  # spec.add_development_dependency "rake"                                    # NOT IN ActiveTriples gemspec file
  spec.add_development_dependency('rdoc')                                     # FROM ActiveTriples gemspec file
  spec.add_development_dependency('rspec')                                    # FROM ActiveTriples gemspec file
  spec.add_development_dependency('guard-rspec')                              # FROM ActiveTriples gemspec file
  spec.add_development_dependency('webmock')                                  # FROM ActiveTriples gemspec file

  spec.extra_rdoc_files = [
      "LICENSE.txt",
      "README.md"
  ]                                                                           # FROM ActiveTriples gemspec file
end

