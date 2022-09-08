# frozen_string_literal: true

module Forms
  class SectionLabelComponent < ViewComponent::Base
    def initialize(cls: '')
      @cls = cls
    end
  end
end
