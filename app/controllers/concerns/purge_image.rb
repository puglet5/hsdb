# frozen_string_literal: true

module PurgeImage
  extend ActiveSupport::Concern

  included do
    def purge_image(signed_id)
      @image = Image.find_signed signed_id
      @image.destroy
    end
  end
end
