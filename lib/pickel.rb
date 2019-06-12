# frozen_string_literal: true

require 'active_record'
require 'active_support/lazy_load_hooks'

require "pickel/condition"
require "pickel/predicate"
require "pickel/search"
require "pickel/version"

module Pickel
  class << self
    def search(klass, search_params)
      Search.new(klass.all, search_params)
    end

    def permit(params, *filters)
      return {} unless params.key?(:q)

      # TODO: Extends filters with predicates
      expanded = filters
      params[:q].permit(*expanded).to_h.reject { |_, v| v.blank? }
    end
  end
end

ActiveSupport.on_load :action_controller do
  require "pickel/view_helper"
  ::ActionController::Base.helper(Pickel::ViewHelper)
end
