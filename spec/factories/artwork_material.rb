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
FactoryBot.define do
  factory :artwork_material do
    association :artwork, factory: :artwork, strategy: :build
    association :material, factory: :material, strategy: :build
  end
end
