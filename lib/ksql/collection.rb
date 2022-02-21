# frozen_string_literal: true

module Ksql
  class Collection < Struct.new(:rows)
    include Enumerable

    #
    # * Generate a class to fit ksqlDB query returned data
    # * Populate the collection
    #
    # @param [Hash] struct_schema Struct Schema definition
    # @param [Array] items Collection rows
    #
    def initialize(struct_schema, items)
      struct = Ksql.const_set(id_to_struct(struct_schema['queryId']), Class.new(Struct.new(*struct_schema['columnNames'].map { |n| n.downcase.to_sym })))
      self.rows = items.map { |i| struct.new(*i) }
    end

    #
    # Allow iterations block on Rows
    #
    # @param [Block] &block Block to execute on each row
    #
    # @return [Array] Rows enumerable
    #
    def each(&block)
      rows.each do |r|
        yield(r)
      end
    end

    private

      #
      # Dynamically generate a name based on the ksqlDB Query ID
      #
      # @param [String] id ksqlDB Query ID
      #
      # @return [String] Collection element Struct name
      #
      def id_to_struct(id)
        "Query#{id.strip.gsub('-', '_')}Row"
      end
  end
end
