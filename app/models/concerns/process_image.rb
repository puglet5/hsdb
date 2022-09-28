# frozen_string_literal: true

module ProcessImage
  extend ActiveSupport::Concern

  included do
    def process_image
      ProcessImageJob.perform_later(self)
    end
  end
end
