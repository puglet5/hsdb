# frozen_string_literal: true

class ProcessImageJob < ApplicationJob
  queue_as :default

  def perform(initiator, attachment_id)
    return unless initiator

    attachment = ActiveStorage::Attachment.find_by id: attachment_id
    return unless attachment&.image?

    attachment_name = attachment.name.to_sym
    variants = initiator.class.reflect_on_attachment(attachment_name).variants

    variants.each_key do |k|
      next if attachment.variant(k).key

      attachment.variant(k).processed

      # rubocop:disable Rails/SkipsModelValidations
      initiator.touch
      # rubocop:enable Rails/SkipsModelValidations
    end
  end
end
