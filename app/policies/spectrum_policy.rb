# frozen_string_literal: true

class SpectrumPolicy < ApplicationPolicy
  def create?
    !user.guest?
  end

  def show?
    true
  end

  def update?
    user.has_role?(:admin) || user.author?(record.sample)
  end

  def destroy?
    user.has_role?(:admin) || user.author?(record.sample)
  end
end
