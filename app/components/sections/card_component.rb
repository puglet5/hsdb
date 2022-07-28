# frozen_string_literal: true

module Sections
  class CardComponent < ViewComponent::Base
    def initialize(cls: '')
      @cls = cls
    end
  end
end
