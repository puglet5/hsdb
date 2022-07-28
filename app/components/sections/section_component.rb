# frozen_string_literal: true

class Sections::SectionComponent < ViewComponent::Base
  def initialize(cls: '')
    @cls = cls
  end
end
