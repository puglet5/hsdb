# frozen_string_literal: true

# == Schema Information
#
# Table name: replies
#
#  created_at    :datetime         not null
#  discussion_id :integer          indexed
#  id            :bigint           not null, primary key
#  reply         :text             not null
#  slug          :string
#  updated_at    :datetime         not null
#  user_id       :integer          indexed
#
# Indexes
#
#  index_replies_on_discussion_id  (discussion_id)
#  index_replies_on_user_id        (user_id)
#
# Foreign Keys
#
#  replies_discussion_id_fk  (discussion_id => discussions.id)
#  replies_user_id_fk        (user_id => users.id)
#
FactoryBot.define do
  factory :reply do
    reply { 'test reply' }
    association :user, factory: :user
    association :discussion, factory: :discussion
  end
end
