# frozen_string_literal: true

module Admin
  class UserPolicy < ApplicationPolicy
    def create?
      user.has_role?('admin')
    end

    def update?
      user.has_role?('admin')
    end

    def destroy?
      user.has_role?('admin')
    end

    def index?
      user.has_role?('admin')
    end

    def show?
      user.has_role?('admin')
    end
  end
end
