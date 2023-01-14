# frozen_string_literal: true

# == Schema Information
#
# Table name: artwork_materials
#
#  id          :bigint           not null, primary key
#  artwork_id   :bigint           not null
#  material_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ArtworkMaterial < ApplicationRecord
  belongs_to :artwork
  belongs_to :material
end
