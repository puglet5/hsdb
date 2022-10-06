# frozen_string_literal: true

# rubocop:disable Rails/SkipsModelValidations

class ProcessImageJob < ApplicationJob
  queue_as :default

  def perform(initiator, attachment_id)
    return unless initiator

    attachment = ActiveStorage::Attachment.find_by id: attachment_id
    return unless attachment

    attachment_name = attachment.name.to_sym
    variants = initiator.class.reflect_on_attachment(attachment_name).variants
    image = initiator.send(attachment_name)

    variants.each_key do |k|
      next if image.variant(k).key

      image.variant(k).processed
      initiator.touch
    end
  end
end

# rubocop:enable Rails/SkipsModelValidations
