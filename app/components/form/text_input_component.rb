# frozen_string_literal: true

module Form
  class TextInputComponent < ViewComponent::Base
    def initialize(form:, field:, label: false, hint: false, required: false, v: nil, readonly: false, disabled: false, placeholder: '', cls: '', as: nil, data: nil)
      @cls = cls
      @form = form
      @placeholder = placeholder
      @disabled = disabled
      @readonly = readonly
      @v = v
      @required = required
      @hint = hint
      @label = label
      @as = as
      @field = field
      @data = data
    end
  end
end
