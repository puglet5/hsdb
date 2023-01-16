# frozen_string_literal: true

# == Schema Information
#
# Table name: artwork_materials
#
#  id          :bigint           not null, primary key
#  artwork_id  :bigint           not null, indexed, indexed => [material_id]
#  material_id :bigint           not null, indexed => [artwork_id], indexed
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_artwork_materials_on_artwork_id                  (artwork_id)
#  index_artwork_materials_on_artwork_id_and_material_id  (artwork_id,material_id) UNIQUE
#  index_artwork_materials_on_material_id                 (material_id)
#

RSpec.describe ArtworkMaterial, type: :model do
  describe 'associations' do
    it { should belong_to(:material) }
    it { should belong_to(:artwork) }
  end
end
