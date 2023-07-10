# frozen_string_literal: true

# == Schema Information
#
# Table name: tags
#
#  created_at :datetime         not null
#  id         :bigint           not null, primary key
#  title      :string
#  updated_at :datetime         not null
#
class Tag < ApplicationRecord
  has_many :artwork_tags, dependent: :destroy
  has_many :artworks, through: :artwork_tags
end
