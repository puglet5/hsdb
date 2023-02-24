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

  def request_processing?
    user.has_role?(:admin) || user.author?(record.sample)
  end

  def show_chart_area?
    true
  end

  def show_request_processing_button?
    true
  end

  def show_processing_indicator?
    true
  end
end
