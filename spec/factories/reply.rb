# frozen_string_literal: true

# == Schema Information
#
# Table name: replies
#
#  id            :bigint           not null, primary key
#  reply         :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  discussion_id :integer
#  user_id       :integer
#  slug          :string
#
FactoryBot.define do
  factory :reply do
    reply { 'test reply' }
    association :user, factory: :user
    association :discussion, factory: :discussion
  end
end
