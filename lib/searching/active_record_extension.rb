# frozen_string_literal: true

require "searching/condition"
require "searching/predicate"
require "searching/search"

module Searching
  module ActiveRecordExtension
    extend ActiveSupport::Concern

    module ClassMethods
      def searching(conditions = {}, options = {})
        Search.new(all, conditions, options)
      end
    end
  end
end
