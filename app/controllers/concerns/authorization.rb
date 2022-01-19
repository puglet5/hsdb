# frozen_string_literal: true

module Authorization
  extend ActiveSupport::Concern

  included do
    include Pundit

    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    private

    def user_not_authorized
      flash[:error] = 'You are not authorized to perform this action'
      redirect_to(request.referer || root_path)
    end
  end
end
