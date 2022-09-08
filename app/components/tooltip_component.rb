# frozen_string_literal: true

class TooltipComponent < ViewComponent::Base
  def initialize(tooltip: '', cls: '')
    @cls = cls
    @tooltip = tooltip
  end
end
