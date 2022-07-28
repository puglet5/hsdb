# frozen_string_literal: true

module Svg
  class InfoComponent < ViewComponent::Base
    def initialize(cls: '', solid: false)
      @solid = solid
      @cls = cls
    end
  end
end
