# frozen_string_literal: true

class UploadTag < ApplicationRecord
  belongs_to :upload
  belongs_to :tag
end
