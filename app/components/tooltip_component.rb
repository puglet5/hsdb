# frozen_string_literal: true

class TooltipComponent < ViewComponent::Base
  def initialize(user: nil, tooltip: '', cls: '')
    @cls = cls
    @tooltip = tooltip
    @user = user
  end

  def hidden?
    !@user&.settings(:ui)&.tooltips
  end
end
