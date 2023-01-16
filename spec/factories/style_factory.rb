# frozen_string_literal: true

# == Schema Information
#
# Table name: styles
#
#  id         :bigint           not null, primary key
#  name       :string           indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_styles_on_name  (name) UNIQUE
#
FactoryBot.define do
  factory :style do
    name { 'MyString' }
  end
end
