# frozen_string_literal: true

module Form
  class LabelComponent < ViewComponent::Base
    def initialize(cls: '')
      @cls = cls
    end
  end
end
