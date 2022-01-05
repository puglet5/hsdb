# frozen_string_literal: true

class Reply < ApplicationRecord
  belongs_to :discussion
  belongs_to :user

  validates :reply, presence: true

  extend FriendlyId
  friendly_id :reply, use: %i[slugged finders]

  def should_generate_new_friendly_id?
    reply_changed?
  end
end
