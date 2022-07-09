# frozen_string_literal: true

class UploadPolicy < ApplicationPolicy
  def create?
    !user.guest?
  end

  def update?
    user.has_role?(:admin) || user.has_role?(:moderator) || user.author?(record)
  end

  def update_status?
    user.has_role?(:admin) || user.has_role?(:moderator) || user.author?(record)
  end

  def destroy?
    user.has_role?(:admin) || user.author?(record)
  end

  def index?
    true
  end

  def show?
    true
  end

end
