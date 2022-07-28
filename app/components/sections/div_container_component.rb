# frozen_string_literal: true

module Sections
  class DivContainerComponent < ViewComponent::Base
    def initialize(cls: '')
      @cls = cls
    end
  end
end
