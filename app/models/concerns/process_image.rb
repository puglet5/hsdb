# frozen_string_literal: true

module ProcessImage
  extend ActiveSupport::Concern

  included do
    def process_image(initiator_id, attachment_id)
      ProcessImageJob.perform_later initiator_id, attachment_id
    end
  end
end
