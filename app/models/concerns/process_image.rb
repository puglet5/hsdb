# frozen_string_literal: true

module ProcessImage
  extend ActiveSupport::Concern

  included do
    def process_image(initiator, attachment_id)
      ProcessImageJob.perform_later initiator, attachment_id
    end
  end
end
