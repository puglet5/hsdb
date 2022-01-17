# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user!, only: %i[edit update destroy]

    def index
      respond_to do |format|
        format.html do
          @users = User.order(created_at: :desc)
        end

        format.zip { respond_with_zipped_users }
      end
    end

    def crate; end

    def edit; end

    def update
      params[:user][:role_ids] ||= []
      if @user.update_with_password user_params
        flash[:success] = 'User was successfully updated'
        redirect_to admin_users_path
      else
        render :edit
      end
    end

    def destroy
      @user.destroy
      flash[:success] = 'User was successfully deleted'
      redirect_to admin_users_path
    end

    private

    def respond_with_zipped_users
      compressed_filestream = Zip::OutputStream.write_buffer do |zos|
        User.order(created_at: :desc).each do |user|
          zos.put_next_entry "user_#{user.id}.xlsx"
          zos.print render_to_string(
            locale: false, layout: false, handlers: [:axlsx], formats: [:xlsx],
            template: 'admin/users/user',
            locals: { user: user }
          )
        end
      end

      compressed_filestream.rewind
      send_data compressed_filestream.read, filename: 'users.zip'
    end

    def set_user!
      @user = User.find params[:id]
    end

    def user_params
      list_allowed_params = []
      list_allowed_params += [:email, :first_name, :last_name, :password, :password_confirmation, :organization, :bio, :current_password, :role, { role_ids: [] }] if current_user.has_role?(:admin)
      params.require(:user).permit(list_allowed_params)
    end
  end
end
