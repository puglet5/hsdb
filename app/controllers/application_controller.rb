# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    update_attrs = [:password, :password_confirmation, :current_password, { role_ids: [] }]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end

  include Internationalization
end
