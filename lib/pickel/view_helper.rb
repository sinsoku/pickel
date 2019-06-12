# frozen_string_literal: true

module Pickel
  class FormBuilder < ActionView::Helpers::FormBuilder
    def submit(value = nil, options = {})
      value, options = nil, value if value.is_a?(Hash)
      value ||= '検索' # TODO: I18n support
      super(value, options)
    end
  end

  module ViewHelper
    def form_with(model: nil, scope: nil, url: nil, format: nil, **options)
      return super unless model.is_a?(Search)

      url ||= polymorphic_path(model.klass, format: format)
      scope ||= :q
      options[:builder] ||= FormBuilder
      options[:id] ||= model.html_id
      options[:class] ||= model.html_id
      options[:method] ||= :get

      super(model: model, scope: scope, url: url, **options)
    end

    def form_for(record, options = {}, &block)
      return super unless record.is_a?(Search)

      opts = options.dup
      opts[:scope] = opts.delete(:as)
      opts[:local] = !(opts.delete(:remote) == true)

      form_with(model: record, **opts, &block)
    end
  end
end
