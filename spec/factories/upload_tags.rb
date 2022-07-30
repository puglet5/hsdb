# frozen_string_literal: true

# == Schema Information
#
# Table name: upload_tags
#
#  id         :bigint           not null, primary key
#  upload_id  :bigint           not null
#  tag_id     :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :upload_tag do
    upload { nil }
    tag { nil }
  end
end
