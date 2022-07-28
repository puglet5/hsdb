# frozen_string_literal: true

module Svg
  class DeleteComponent < ViewComponent::Base
    def initialize(cls: '', solid: false)
      @cls = cls
      @solid = solid
    end
  end
end
