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
    upload { nil }
    material { nil }
  end
end
