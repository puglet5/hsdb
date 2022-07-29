# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.friendly.find(params[:id])
  end

  def update_settings
    @user = current_user
    if setting_params
      setting_params[:settings].each do |key, value|
        @user.settings(key.to_sym).update! value
      end
      redirect_to @user
      flash[:success] = 'Settings updated!'
    end
  end

  private

  def setting_params
    params.require(:user).permit(settings: { processing: :enabled, pagination: :per })
  end
end
