# frozen_string_literal: true

module Sections
  class SectionComponent < ViewComponent::Base
    def initialize(cls: '')
      @cls = cls
    end
  end
end
