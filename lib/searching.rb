# frozen_string_literal: true

require "searching/version"
require 'active_support/lazy_load_hooks'

ActiveSupport.on_load :active_record do
  require "searching/active_record_extension"
  ::ActiveRecord::Base.include(Searching::ActiveRecordExtension)
end

ActiveSupport.on_load :action_controller do
  require "searching/view_helper"
  ::ActionController::Base.helper(Searching::ViewHelper)
end
