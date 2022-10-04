# frozen_string_literal: true

module Forms
  class LabelComponent < ViewComponent::Base
    def initialize(cls: '', optional: true)
      @cls = cls
      @optional = optional
    end
  end
end
