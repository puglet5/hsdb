# frozen_string_literal: true

class ProcessImageJob < ApplicationJob
  queue_as :default

  def perform(obj)
    puts obj.image&.representable?
    obj.image.variant(:thumbnail).processed if obj.image&.representable?
  end
end
