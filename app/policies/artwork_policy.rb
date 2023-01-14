# frozen_string_literal: true

class ArtworkPolicy < ApplicationPolicy
  def create?
    !user.guest?
  end

  def update?
    user.has_role?(:admin) || user.author?(record)
  end

  def update_status?
    user.has_role?(:admin) || user.author?(record)
  end

  def destroy?
    user.has_role?(:admin) || user.author?(record)
  end

  def purge_attachment?
    user.has_role?(:admin) || user.author?(record)
  end

  def index?
    true
  end

  def show?
    true
  end

  def images?
    true
  end

  def images_grid?
    true
  end
end
