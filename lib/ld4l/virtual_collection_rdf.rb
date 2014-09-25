require 'rdf'
require 'active_triples'
require 'ld4l/virtual_collection_rdf/version'

module LD4L
  module VirtualCollectionRDF

    # Methods for configuring the GEM
    class << self
      attr_accessor :configuration
    end

    def self.configuration
      @configuration ||= Configuration.new
    end

    def self.reset
      @configuration = Configuration.new
    end

    def self.configure
      yield(configuration)
    end


    # RDF vocabularies
    autoload :CNT,                 'ld4l/virtual_collection_rdf/vocab/cnt'
    autoload :CO,                  'ld4l/virtual_collection_rdf/vocab/co'
    autoload :DCTERMS,             'ld4l/virtual_collection_rdf/vocab/dcterms'
    autoload :DCTYPES,             'ld4l/virtual_collection_rdf/vocab/dctypes'
    autoload :IANA,                'ld4l/virtual_collection_rdf/vocab/iana'
    autoload :ORE,                 'ld4l/virtual_collection_rdf/vocab/ore'


    # autoload classes
    autoload :Configuration,       'ld4l/virtual_collection_rdf/configuration'
    autoload :Person,              'ld4l/virtual_collection_rdf/person'
    autoload :ResourceExtension,   'ld4l/virtual_collection_rdf/resource_extension'
    autoload :Collection,          'ld4l/virtual_collection_rdf/collection'
    autoload :Item,                'ld4l/virtual_collection_rdf/item'

    def self.class_from_string(class_name, container_class=Kernel)
      container_class = container_class.name if container_class.is_a? Module
      container_parts = container_class.split('::')
      (container_parts + class_name.split('::')).flatten.inject(Kernel) do |mod, class_name|
        if mod == Kernel
          Object.const_get(class_name)
        elsif mod.const_defined? class_name.to_sym
          mod.const_get(class_name)
        else
          container_parts.pop
          class_from_string(class_name, container_parts.join('::'))
        end
      end
    end

  end
end

