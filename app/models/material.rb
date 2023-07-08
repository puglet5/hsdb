# frozen_string_literal: true

# == Schema Information
#
# Table name: materials
#
#  created_at :datetime         not null
#  id         :bigint           not null, primary key
#  name       :string           not null, indexed
#  updated_at :datetime         not null
#
# Indexes
#
#  index_materials_on_name  (name) UNIQUE
#
class Material < ApplicationRecord
  has_many :artwork_materials, dependent: :destroy
  has_many :artworks, through: :artwork_materials

  validates :name, presence: true, uniqueness: true
end
