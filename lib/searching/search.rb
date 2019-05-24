# frozen_string_literal: true

module Searching
  class Search
    include ActiveModel::Model

    def initialize(relation, params = {}, _options = {})
      @relation = relation
      @klass = relation.klass
      @params = params ? params.transform_keys(&:to_sym) : {}
      @sorts = []
      @sorts << @params.delete(:s)
      @sorts << @params.delete(:sorts)
      @sorts.compact!
    end
    attr_reader :relation, :klass, :params, :sorts
    alias s sorts

    def sorts=(args)
      @sorts = args
    end
    alias s= sorts=

    def result
      conditions = params.map { |k, v| Condition.for(klass, k).build(v) }

      if sorts.empty?
        conditions.inject(relation, :merge)
      else
        conditions.inject(relation, :merge).order(sorts)
      end
    end

    def method_missing(method_id, *args)
      method_name = method_id.to_s
      getter_name = method_name.delete_suffix('=')
      predicate = Predicate.find(getter_name)

      if predicate && method_name.end_with?('=')
        params[getter_name] = *args
      elsif predicate
        params[getter_name]
      else
        super
      end
    end
  end
end
