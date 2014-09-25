require 'rdf'
require 'active_triples'
require "ld4l/virtual_collection_rdf/version"

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
    VOCABS = Dir.glob(File.join(File.dirname(__FILE__), 'virtual_collection_rdf', 'vocab', '*.rb')).map { |f| File.basename(f)[0...-(File.extname(f).size)].to_sym } rescue []
    VOCABS.each { |v| autoload v.to_s.upcase.to_sym, "ld4l/virtual_collection_rdf/vocab/#{v}" }

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

