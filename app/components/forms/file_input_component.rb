# frozen_string_literal: true

module Forms
  class FileInputComponent < ViewComponent::Base
    def initialize(form:, field:, accept: '', label: false, hint: false, required: false, direct: false, value: nil, multiple: false, cls: '')
      @cls = cls
      @form = form
      @multiple = multiple
      @value = value
      @direct = direct
      @required = required
      @hint = hint
      @label = label
      @accept = accept
      @field = field
    end
  end
end
