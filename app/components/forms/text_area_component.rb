# frozen_string_literal: true

module Forms
  class TextAreaComponent < ViewComponent::Base
    def initialize(cls:, form:, placeholder:, disabled:, readonly:, value:, required:, hint:, label:)
      @cls = cls
      @form = form
      @placeholder = placeholder
      @disabled = disabled
      @readonly = readonly
      @value = value
      @required = required
      @hint = hint
      @label = label
    end
  end
end
