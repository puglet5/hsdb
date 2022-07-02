# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include PublicActivity::StoreController
  include Internationalization
  include Authorization
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  def configure_permitted_parameters
    update_attrs = [:avatar, :first_name, :last_name, :organization, :password, :password_confirmation, :current_password, { role_ids: [] }]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
    devise_parameter_sanitizer.permit :sign_up, keys: update_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: %i[login password]
  end
end
