# frozen_string_literal: true

class SendProcessingRequestJob < ApplicationJob
  queue_as :default

  def perform(initiator)
    return unless initiator

    record_type = initiator.class.name.downcase
    record_id = initiator.id

    ProcessingRequestSender.call record_type, record_id
  end
end
