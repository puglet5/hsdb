# frozen_string_literal: true

class CategoryPolicy < ApplicationPolicy
  def create?
    user.has_role?(:admin)
  end

  def update?
    user.has_role?(:admin)
  end

  def update_status?
    user.has_role?(:admin)
  end

  def destroy?
    user.has_role?(:admin)
  end

  def index?
    true
  end

  def show?
    true
  end
end
