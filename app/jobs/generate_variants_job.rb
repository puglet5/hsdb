# frozen_string_literal: true

class GenerateVariantsJob < ApplicationJob
  queue_as :default

  def perform(id)
    upload = Upload.find id

    upload&.image_attachments&.each do |image|
      next unless image.representable?

      preview_variant = image.variant(:thumbnail)
      preview_variant.process unless preview_variant.processed?
    end
  end
end
