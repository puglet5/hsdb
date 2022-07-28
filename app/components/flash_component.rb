# frozen_string_literal: true

class FlashComponent < ViewComponent::Base
  def initialize(type: '', msg: '', cls: '')
    @cls = cls
    @type = type
    @msg = msg
  end
end
