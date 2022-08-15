# frozen_string_literal: true

class UploadMaterial < ApplicationRecord
  belongs_to :upload
  belongs_to :material
end
