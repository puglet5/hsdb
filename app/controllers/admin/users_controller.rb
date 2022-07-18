# frozen_string_literal: true

module Admin
  class UsersController < BaseController
    before_action :authenticate_user!
    before_action :set_user!, only: %i[edit update destroy]
    before_action :authorize_user!
    after_action :verify_authorized

    def index
      respond_to do |format|
        format.html do
          @users = User.order(created_at: :asc)
        end

        format.zip { respond_with_zipped_users }
      end
    end

    def crate; end

    def edit
      @roles = Role.all
    end

    def update
      params[:user][:role_ids] ||= []

      if params[:user][:password].blank?
        params[:user].delete('password')
        params[:user].delete('password_confirmation')
      end

      if @user.update user_params
        flash[:success] = 'User was successfully updated'
        redirect_to admin_users_path
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @user.destroy
      flash[:success] = 'User was successfully deleted'
      redirect_to admin_users_path, status: :see_other
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
      list_allowed_params = [:avatar, :email, :first_name, :last_name, :password, :organization, :bio, { role_ids: [] }]
      params.require(:user).permit(list_allowed_params)
    end

    def authorize_user!
      authorize(@user || User)
    end
  end
end
