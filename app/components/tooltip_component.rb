# frozen_string_literal: true

class TooltipComponent < ViewComponent::Base
  def initialize(user: nil, tooltip: '', text: '', cls: '')
    @cls = cls
    @tooltip = tooltip
    @text = text
    @user = user
  end

  def hidden?
    !@user&.settings(:ui)&.tooltips
  end
end
