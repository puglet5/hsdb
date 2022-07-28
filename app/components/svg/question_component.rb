# frozen_string_literal: true

module Svg
  class QuestionComponent < ViewComponent::Base
    def initialize(cls: '', solid: false)
      @cls = cls
      @solid = solid
    end
  end
end
