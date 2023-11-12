# frozen_string_literal: true

class SpectrumStatusBadgeComponent < ViewComponent::Base
  attr_reader :status, :message

  def initialize(user:, status: '', message: '', cls: '')
    @status = status
    @message = message
    @cls = cls
    @user = user
  end
end
