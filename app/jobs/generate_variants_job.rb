# frozen_string_literal: true

class GenerateVariantsJob < ApplicationJob
  queue_as :default

  def perform(id)
    Upload.find_by(id: id).images.each do |image|
      next unless image&.representable?

      preview_variant = image.variant(resize: '400x300^', crop: '400x300+0+0')
      preview_variant.process unless preview_variant.processed?
    end
  end
end
