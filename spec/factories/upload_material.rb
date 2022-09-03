# frozen_string_literal: true

# == Schema Information
#
# Table name: upload_materials
#
#  id          :bigint           not null, primary key
#  upload_id   :bigint           not null
#  material_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :upload_material do
    association :upload, factory: :upload, strategy: :build
    association :material, factory: :material, strategy: :build
  end
end
