require 'rdf'
module RDFVocabularies
  class IANA < RDF::Vocabulary("http://www.iana.org/assignments/relation/")
    property :next        # URI of next item
    property :previous    # URI of previous item
  end
end
