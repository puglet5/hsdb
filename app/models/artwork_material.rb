# frozen_string_literal: true

# == Schema Information
#
# Table name: artwork_materials
#
#  artwork_id  :bigint           not null, indexed, indexed => [material_id]
#  created_at  :datetime         not null
#  id          :bigint           not null, primary key
#  material_id :bigint           not null, indexed => [artwork_id], indexed
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_artwork_materials_on_artwork_id                  (artwork_id)
#  index_artwork_materials_on_artwork_id_and_material_id  (artwork_id,material_id) UNIQUE
#  index_artwork_materials_on_material_id                 (material_id)
#
# Foreign Keys
#
#  fk_rails_3f1e6fb54f  (material_id => materials.id)
#  fk_rails_a316e2fe05  (artwork_id => artworks.id)
#
class ArtworkMaterial < ApplicationRecord
  belongs_to :artwork
  belongs_to :material
end
