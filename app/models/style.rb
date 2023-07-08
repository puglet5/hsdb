# frozen_string_literal: true

# == Schema Information
#
# Table name: styles
#
#  created_at :datetime         not null
#  id         :bigint           not null, primary key
#  name       :string           indexed
#  updated_at :datetime         not null
#
# Indexes
#
#  index_styles_on_name  (name) UNIQUE
#
class Style < ApplicationRecord
  has_many :artworks, dependent: nil

  validates :name, presence: true, uniqueness: true
end
