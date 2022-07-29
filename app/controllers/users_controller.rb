# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.friendly.find(params[:id])
  end

  def update_settings
    return unless setting_params

    @user = current_user

    setting_params[:settings].each do |key, value|
      @user.settings(key.to_sym).update! value
    end
    redirect_to @user
    flash[:success] = 'Settings updated!'
  end

  private

  def setting_params
    params.require(:user).permit(settings: { processing: :enabled, pagination: :per })
  end
end
