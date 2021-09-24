require 'hashie'
require 'active_support/core_ext/hash/indifferent_access'
require 'jsonapi_deserializer/version'
require 'jsonapi_deserializer/configuration'

module JSONApi
  class Deserializer
    class Assocation < Hashie::Mash
      include Hashie::Extensions::MethodAccess
      include Hashie::Extensions::IndifferentAccess

      def initialize(source_hash = nil, default = nil, &blk)

        if source_hash[:id]
          source_hash[:id] = source_hash[:id].to_s
        end

        if source_hash[:lid]
          source_hash[:lid] = source_hash[:lid].to_s
        end
        super
      end
    end

    class Record < Hashie::Mash
      include Hashie::Extensions::MethodAccess
      include Hashie::Extensions::IndifferentAccess
      include Hashie::Extensions::DeepFetch

      def initialize(source_hash = nil, default = nil, &blk)
        if source_hash[:id]
          source_hash[:id] = source_hash[:id].to_s
        end

        if source_hash[:lid]
          source_hash[:lid] = source_hash[:lid].to_s
        end
        super
      end
    end

    class Store
      def initialize
        @db = {}
      end

      def set(type, id, lid, record)
        per_type = @db[type] ||= {}
        identifier = id || lid

        per_type[identifier.to_s] = record
      end

      def get(type, id, lid)
        per_type = @db[type]
        return nil unless per_type

        identifier = id || lid
        per_type[identifier.to_s]
      end
    end

    def initialize(response)
      @response = response.is_a?(Hash) ? response.with_indifferent_access : response
      @store = Store.new

      all_data = ([] << @response[:data] << @response[:included]).flatten.compact
      store_records(all_data)
      build_associations(all_data)
    end

    def deserialized_hash
      data = @response[:data]

      if data.is_a? Array
        data.map { |datum| @store.get(datum[:type], datum[:id], datum[:lid]) }
      else
        @store.get(data[:type], data[:id], data[:lid])
      end
    end

    private

    def store_records(data)
      data.each do |datum|
        record = if self.class.configuration.support_lids
          Record.new(id: datum[:id], lid: datum[:lid]).merge(datum[:attributes] || {})
        else
          Record.new(id: datum[:id]).merge(datum[:attributes] || {})
        end

        @store.set(datum[:type], datum[:id], datum[:lid], record)
      end
    end

    def find_association(association)
      return nil unless association
      @store.get(association[:type], association[:id], association[:lid]) || Assocation.new(association)
    end

    def build_associations(data)
      data.each do |datum|
        record = @store.get(datum[:type], datum[:id], datum[:lid])

        relationships = datum[:relationships] || {}
        relationships.each do |relationship_name, relationship|
          if relationship[:data].is_a? Array
            record[relationship_name] = relationship[:data].map { |assoc| find_association(assoc) }
          else
            record[relationship_name] = find_association(relationship[:data])
          end
        end
      end
    end
  end
end
