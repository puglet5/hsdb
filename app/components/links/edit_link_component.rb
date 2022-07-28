# frozen_string_literal: true

module Links
  class EditLinkComponent < ViewComponent::Base
    def initialize(cls:, path:, svg:)
      @cls = cls
      @path = path
      @svg = svg
    end
  end
end
