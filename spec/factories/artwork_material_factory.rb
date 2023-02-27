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
# Foreign Keys
#
#  fk_rails_...  (artwork_id => artworks.id)
#  fk_rails_...  (material_id => materials.id)
#
FactoryBot.define do
  factory :artwork_material do
    association :artwork, factory: :artwork, strategy: :build
    association :material, factory: :material, strategy: :build
  end
end
