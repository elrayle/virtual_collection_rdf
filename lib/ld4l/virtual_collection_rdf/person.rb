Dir["lib/ld4l/virtual_collection_rdf/vocab/*.rb"].each {|file| require file[4,file.size-3] }

module LD4L
  module VirtualCollectionRDF
    class Person < LD4L::VirtualCollectionRDF::ResourceExtension

      @id_prefix="p"

      configure :type => RDF::FOAF.Person, :base_uri => LD4L::VirtualCollectionRDF.configuration.person_base_uri, :repository => :default
    end
  end
end
