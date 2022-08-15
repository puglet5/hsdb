# frozen_string_literal: true

class Material < ApplicationRecord
  has_many :upload_materials, dependent: :destroy
  has_many :uploads, through: :upload_materials
end
