# frozen_string_literal: true

# == Schema Information
#
# Table name: materials
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Material < ApplicationRecord
  has_many :upload_materials, dependent: :destroy
  has_many :uploads, through: :upload_materials

  validates :name, presence: true, uniqueness: true
end
