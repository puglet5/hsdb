# frozen_string_literal: true

class ProcessImageJob < ApplicationJob
  queue_as :default

  def perform(obj)
    unless obj.image.variant(:thumbnail).key
      obj.image.variant(:thumbnail).processed
      obj.touch
    end
  end
end
