# frozen_string_literal: true

module Searching
  module ViewHelper
    def search_form_for(search, options = {}, &block)
      klass = search.klass
      options[:url] ||= polymorphic_path(klass, format: options.delete(:format))
      options[:as] ||= :q
      options[:html] ||= {}
      options[:html].reverse_merge!(
        id: "#{klass.to_s.underscore}_search",
        class: "#{klass.to_s.underscore}_search",
        method: :get
      )

      form_for(search, options, &block)
    end
  end
end
