# frozen_string_literal: true

module Searching
  class Predicate
    AREL = %i[eq in not_eq not_in lt lteq gt gteq matches].freeze
    MATCHES = %i[cont start end].flat_map { |x| [x, "not_#{x}".to_sym] }.freeze
    LITERAL = %i[true false null].flat_map { |x| [x, "not_#{x}".to_sym] }.freeze
    DERIVED = %i[blank present].freeze
    ESCAPE_ADAPTERS = %w[Mysql2 PostgreSQL].freeze

    class << self
      def all
        @all ||= [AREL, MATCHES, LITERAL, DERIVED].flatten.map { |id| new(id) }
      end

      def find(id)
        all.find { |predicate| id.end_with?("_#{predicate.id}") }
      end
    end

    def initialize(id)
      @id = id
    end
    attr_reader :id

    def build(klass, column, value)
      v = convert(value)
      args =
        case id
        when *AREL
          klass.arel_table[column].public_send(id, v)
        when *MATCHES
          klass.arel_table[column].matches(v)
        when :blank
          klass.arel_table[column].eq_any([nil, ''])
        when :present
          klass.arel_table[column].not_eq_any(nil)
        else
          { column => v }
        end

      when_not?(v) ? klass.where.not(args) : klass.where(args)
    end

    private

    def convert(value)
      case id
      when :cont, :not_cont
        "%#{escape_wildcards(value)}%"
      when :start, :not_start
        "#{escape_wildcards(value)}%"
      when :end, :not_end
        "%#{escape_wildcards(value)}"
      when :true, :not_true
        true
      when :false, :not_false
        false
      when :null, :not_null
        nil
      else
        value
      end
    end

    # replace % \ to \% \\
    def escape_wildcards(unescaped)
      if ESCAPE_ADAPTERS.include?(ActiveRecord::Base.connection.adapter_name)
        unescaped.to_s.gsub(/([\\%_.])/, '\\\\\\1')
      else
        unescaped
      end
    end

    def when_not?(value)
      !AREL.include?(id) && (id.to_s.start_with?('not') || !value)
    end
  end
end
