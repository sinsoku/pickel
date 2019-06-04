# frozen_string_literal: true

module Searching
  class FormBuilder < ActionView::Helpers::FormBuilder
    def submit(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)
      value ||= '検索' # TODO: I18n support
      super(value, options)
    end
  end

  module ViewHelper
    def search_form_for(search, options = {}, &block)
      klass = search.klass
      options[:url] ||= polymorphic_path(klass, format: options.delete(:format))
      options[:as] ||= :q
      options[:builder] ||= FormBuilder
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
