# frozen_string_literal: true

module Typography
  class H1Component < ViewComponent::Base
    def initialize(cls: '')
      @cls = cls
    end
  end
end
