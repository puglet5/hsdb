# frozen_string_literal: true

class Sections::DivContainerComponent < ViewComponent::Base
  def initialize(cls: '')
    @cls = cls
  end
end
