# frozen_string_literal: true

module Form
  class SubmitComponent < ViewComponent::Base
    def initialize(form:, cls: '')
      @cls = cls
      @form = form
    end
  end
end
