# frozen_string_literal: true

# rubocop:disable Rails/SkipsModelValidations

class ProcessImageJob < ApplicationJob
  queue_as :default

  def perform(initiator_id, attachment_id)
    attachment = ActiveStorage::Attachment.find_by id: attachment_id
    return unless attachment

    record_type = attachment.record_type.constantize

    record = record_type.find_by id: initiator_id
    return unless record

    attachment_name = attachment.name.to_sym
    variants = record_type.reflect_on_attachment(attachment_name).variants
    image = record.send(attachment_name)

    variants.each_key do |k|
      next if image.variant(k).key

      image.variant(k).processed
      record.touch
    end
  end
end

# rubocop:enable Rails/SkipsModelValidations
