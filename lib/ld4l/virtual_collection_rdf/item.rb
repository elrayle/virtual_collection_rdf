Dir["lib/ld4l/virtual_collection_rdf/vocab/*.rb"].each {|file| require file[4,file.size-3] }

module LD4L
  module VirtualCollectionRDF
    class Item < LD4L::VirtualCollectionRDF::ResourceExtension

      @id_prefix="vci"

      ORE_UNORDERED_LIST_ITEM_TYPE = RDFVocabularies::ORE.Proxy
      ORE_ORDERED_LIST_ITEM_TYPE   = RDFVocabularies::ORE.Proxy
      # CO_UNORDERED_LIST_ITEM_TYPE  = RDFVocabularies::CO.Element
      # CO_ORDERED_LIST_ITEM_TYPE    = RDFVocabularies::CO.ListItem


      # configure :base_uri => LD4L::VirtualCollectionRDF.configuration.base_uri, repository => :default
      configure :type => ORE_UNORDERED_LIST_ITEM_TYPE, :base_uri => LD4L::VirtualCollectionRDF.configuration.base_uri, :repository => :default

      # common properties
      property :type,          :predicate => RDF::type             # multiple: CO.Element, CO.ListItem, ORE.Proxy
      property :contributor,   :predicate => RDF::DC.contributor,            :class_name => LD4L::VirtualCollectionRDF::Person   # TODO User who added this item to the Virtual Collection (default=Virtual Collection's owner)

      # # properties from CO.Element
      # property :itemContent,   :predicate => RDFVocabularies::CO.itemContent
      #
      # # extended properties from CO.ListItem (also uses properties for CO.Element)
      # property :index,         :predicate => RDFVocabularies::CO.index                                            # TODO Maintenance of index is onerous as an insert requires touching O(N-index) items, but having an index will help with retrieving ranges of items
      # property :nextItem,      :predicate => RDFVocabularies::CO.nextItem,   :class_name => LD4L::VirtualCollectionRDF::Item
      # property :previousItem,  :predicate => RDFVocabularies::CO.nextItem,   :class_name => LD4L::VirtualCollectionRDF::Item

      # properties from ORE.Proxy
      property :proxyFor,      :predicate => RDFVocabularies::ORE.proxyFor
      property :proxyIn,       :predicate => RDFVocabularies::ORE.proxyIn,   :class_name => LD4L::VirtualCollectionRDF::Collection
      property :next,          :predicate => RDFVocabularies::IANA.next,     :class_name => LD4L::VirtualCollectionRDF::Item
      property :previous,      :predicate => RDFVocabularies::IANA.previous, :class_name => LD4L::VirtualCollectionRDF::Item


      # --------------------- #
      #    HELPER METHODS     #
      # --------------------- #

      # Create a virtual collection item in one step passing in the required information.  ORE ontology only.
      #   options:
      #     id                 (optional) - used to assign RDFSubject
      #                - full URI   - used as passed in
      #                - partial id - uri generated from base_uri + id_prefix + id
      #                - nil        - uri generated from base_uri + id_prefix + random_number
      #     virtual_collection (required) - collection to which item is being added
      #     content            (required) - content for the item being added to the collection
      #     insert_position    (optional) - used for ordered lists to place an item at a specific location (default - appends)
      #     contributor        (optional) - assumed to be list owner if not specified
      def self.create( options = {} )
        # validate item was passed in
        content = options[:content] || nil
        raise ArgumentError, "content is required" if content.nil?

        # validate virtual_collection is of correct type
        virtual_collection = options[:virtual_collection] || nil
        raise ArgumentError, "virtual_collection is not LD4L::VirtualCollectionRDF::Collection" unless virtual_collection.kind_of?(LD4L::VirtualCollectionRDF::Collection)

        id  = options[:id] || generate_id
        vci = LD4L::VirtualCollectionRDF::Item.new(id)

        # set ORE ontology properties
        vci.proxyFor    = content
        vci.proxyIn     = virtual_collection.kind_of?(String) ? RDF::URI(virtual_collection) : virtual_collection

        # # set Collections ontology properties
        # vci.itemContent = content

        # types = [ CO_UNORDERED_LIST_ITEM_TYPE, ORE_UNORDERED_LIST_ITEM_TYPE ]
        types = ORE_UNORDERED_LIST_ITEM_TYPE
        insert_position = options[:insert_position] || nil
        unless insert_position.nil?
          # TODO: handle inserting item into an ordered list at position specified
          # set nextItem, previousItem, next, and previous properties
          # update other items that are near it
          # TODO: what happens if prev and next aren't set on the
          # types = [ CO_ORDERED_LIST_ITEM_TYPE, ORE_ORDERED_LIST_ITEM_TYPE ]
          types = ORE_ORDERED_LIST_ITEM_TYPE
        end
        vci.contributor = options[:contributor] || []   # TODO default to vc.owner

        vci.type = types
        vci
      end


      # Returns an array of the LD4L::VirtualCollectionRDF::Item instances for the items in the virtual collection
      # TODO: How to begin at start and limit to number of returned items, effectively handling ranges of data.
      def self.get_range( virtual_collection, start=0, limit=nil )
        # TODO: Stubbed to return all items.  Need to implement start and limit features.
        r = ActiveTriples::Repositories.repositories[LD4L::VirtualCollectionRDF::Item.repository]
        vci_array = []
        r.query(:predicate => RDFVocabularies::ORE.proxyIn,
                :object => virtual_collection.rdf_subject).statements.each do |s|
          vci = LD4L::VirtualCollectionRDF::Item.new(s.subject)
          vci_array << vci
        end
        vci_array
      end
    end
  end
end