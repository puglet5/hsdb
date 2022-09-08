# frozen_string_literal: true

module Forms
  class SubmitComponent < ViewComponent::Base
    def initialize(form:, cls: '')
      @cls = cls
      @form = form
    end
  end
end
