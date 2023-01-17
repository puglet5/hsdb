# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.friendly.find(params[:id])
  end

  def update_settings
    return unless setting_params

    @user = current_user

    setting_params[:settings].each do |key, value|
      # This is a workaround for the fact that checkboxes in settings form return boolean values as strings instead. Will need to move this bit in a separate concern later.

      # ActiveModel::Type::Boolean.new.cast(nil) = nil, so its safe to have missing keys.

      case key
      when 'processing'
        value['enabled'] = ActiveModel::Type::Boolean.new.cast(value['enabled'])
      when 'uploading'
        value['thumbnails'] = ActiveModel::Type::Boolean.new.cast(value['thumbnails'])
      when 'ui'
        value['tooltips'] = ActiveModel::Type::Boolean.new.cast(value['tooltips'])
        value['breadcrumbs'] = ActiveModel::Type::Boolean.new.cast(value['breadcrumbs'])
      end

      @user.settings(key.to_sym).update! value
    end
    redirect_to @user
    flash.keep[:success] = 'Settings updated!'
  end

  private

  def setting_params
    # TODO: rewrite this to permit all params in settings hash
    params.require(:user).permit(settings:
                                  {
                                    processing: :enabled,
                                    pagination: :per,
                                    uploading: :thumbnails,
                                    ui: %i[tooltips breadcrumbs]
                                  })
  end
end
