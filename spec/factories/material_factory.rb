# frozen_string_literal: true

# == Schema Information
#
# Table name: materials
#
#  id         :bigint           not null, primary key
#  name       :string           not null, indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_materials_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :material do
    name { 'MyString' }
  end
end
