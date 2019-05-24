# frozen_string_literal: true

module Searching
  class Condition
    class << self
      def for(klass, key)
        s_key = key.to_s
        predicate = Predicate.find(s_key)

        cond = new(klass: klass, predicate: predicate)
        new_key = s_key.delete_suffix("_#{predicate.id}")
        cond.assign_column(new_key)
      end
    end

    def initialize(klass:, predicate:, column: nil, target: nil, join_tables: [])
      @klass = klass
      @predicate = predicate
      @column = column
      @target = target
      @join_tables = join_tables
    end
    attr_reader :klass, :predicate, :column, :target, :join_tables

    def assign_column(key, target: klass, join_tables: [])
      base = { klass: klass, predicate: predicate, target: target, join_tables: join_tables }
      return Condition.new(base.merge(column: key)) if target.attribute_names.include?(key)

      association = target.reflect_on_all_associations.find { |a| key.start_with?(a.name.to_s) }
      if association
        new_key = key.delete_prefix("#{association.name}_")
        join_tables << association.name
        new_target = association.klass

        assign_column(new_key, target: new_target, join_tables: join_tables)
      else
        Condition.new(base.merge(predicate: nil))
      end
    end

    def build(value)
      return klass.all if predicate.nil?

      rel = predicate.build(target, column, value)
      join_tables.empty? ? rel : join_relation.merge(rel)
    end

    private

    def join_relation
      args = join_tables.reverse_each.inject { |a, b| { b => a } }
      klass.joins(args)
    end
  end
end
