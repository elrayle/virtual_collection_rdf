require 'rdf'

module LD4L
  module VirtualCollectionRDF
    class Person < LD4L::VirtualCollectionRDF::ResourceExtension

      @id_prefix="p"

      configure :type => RDF::FOAF.Person, :base_uri => LD4L::VirtualCollectionRDF.configuration.person_base_uri, :repository => :default
    end
  end
end
