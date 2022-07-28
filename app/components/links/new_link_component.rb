# frozen_string_literal: true

module Links
  class NewLinkComponent < ViewComponent::Base
    def initialize(path: '', cls: '', svg: true)
      @cls = cls
      @path = path
      @svg = svg
    end
  end
end
