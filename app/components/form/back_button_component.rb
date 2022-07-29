# frozen_string_literal: true

module Form
  class BackButtonComponent < ViewComponent::Base
    def initialize(cls: '', path: '')
      @cls = cls
      @path = path
    end
  end
end
