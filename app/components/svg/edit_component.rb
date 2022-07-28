# frozen_string_literal: true

module Svg
  class EditComponent < ViewComponent::Base
    def initialize(cls: '', solid: false)
      @solid = solid
      @cls = cls
    end
  end
end
