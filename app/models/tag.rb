# frozen_string_literal: true

class Tag < ApplicationRecord
  has_many :upload_tags, dependent: :destroy
  has_many :uploads, through: :upload_tags
end
