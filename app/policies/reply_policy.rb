# frozen_string_literal: true

class ReplyPolicy < ApplicationPolicy
  def create?
    !user.guest?
  end

  def update?
    user.has_role?(:admin) || user.author?(record)
  end

  def destroy?
    user.has_role?(:admin) || user.author?(record)
  end

  def show?
    true
  end
end
