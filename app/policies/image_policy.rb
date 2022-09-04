# frozen_string_literal: true

class ImagePolicy < ApplicationPolicy
  def create?
    true
  end

  def update?
    true
  end

  def update_status?
    true
  end

  def destroy?
    true
  end

  def purge_attachment?
    true
  end

  def index?
    true
  end

  def show?
    true
  end
end
