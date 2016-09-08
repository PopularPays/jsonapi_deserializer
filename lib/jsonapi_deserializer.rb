require "hashie"
require "active_support/core_ext/hash/indifferent_access"
require "jsonapi_deserializer/version"

module JSONApi
  class Deserializer
    class Assocation < Hashie::Mash
      include Hashie::Extensions::MethodAccess
      include Hashie::Extensions::IndifferentAccess

      def initialize(source_hash = nil, default = nil, &blk)
        source_hash[:id] = source_hash[:id].to_s
        super
      end
    end

    class Record < Hashie::Mash
      include Hashie::Extensions::MethodAccess
      include Hashie::Extensions::IndifferentAccess
      include Hashie::Extensions::DeepFetch
    end

    def initialize(response)
      @response = response.with_indifferent_access
      @store = {}

      all_data = ([] << @response[:data] << @response[:included]).flatten.compact
      store_records(all_data)
      build_associations(all_data)
    end

    def deserialized_hash
      data = @response[:data]
      if data.is_a? Array
        data.map { |datum| @store[datum[:type]][datum[:id].to_s] }
      else
        @store[data[:type]][data[:id].to_s]
      end
    end

    private

    def store_records(data)
      data.each do |datum|
        type = datum[:type]
        per_type = @store[type] ||= {}
        record = Record.new(id: datum[:id].to_s).merge(datum[:attributes] || {})

        per_type[record.id] = record
      end
    end

    def find_association(association)
      return nil unless association
      if @store[association[:type]] && @store[association[:type]][association[:id].to_s]
        @store[association[:type]][association[:id].to_s]
      else
        Assocation.new(association)
      end
    end

    def build_associations(data)
      data.each do |datum|
        record = @store[datum[:type]][datum[:id].to_s]

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
