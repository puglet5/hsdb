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
class Reply < ApplicationRecord
  # include PublicActivity::Model
  # tracked owner: proc { |controller, _model| controller.current_user }

  include Authorship

  belongs_to :discussion
  belongs_to :user

  validates :reply, presence: true

  def should_generate_new_friendly_id?
    slug.blank? || reply_changed?
  end
end
