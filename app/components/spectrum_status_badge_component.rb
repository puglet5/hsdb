# frozen_string_literal: true

class SpectrumStatusBadgeComponent < ViewComponent::Base
  attr_reader :status

  def initialize(user:, status: '', cls: '')
    @status = status
    @cls = cls
    @user = user
  end
end
