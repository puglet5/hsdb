# frozen_string_literal: true

# rubocop:disable Rails/SkipsModelValidations

class ProcessImageJob < ApplicationJob
  queue_as :default

  def perform(obj)
    return if obj.image.variant(:thumbnail).key

    obj.image.variant(:thumbnail).processed
    obj.touch
  end
end

# rubocop:enable Rails/SkipsModelValidations
