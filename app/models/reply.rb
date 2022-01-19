# frozen_string_literal: true

class Reply < ApplicationRecord
  include PublicActivity::Model
  include Authorship

  tracked owner: proc { |controller, _model| controller.current_user }

  belongs_to :discussion
  belongs_to :user

  validates :reply, presence: true

  extend FriendlyId
  friendly_id :reply, use: %i[slugged finders]

  def should_generate_new_friendly_id?
    slug.blank? || reply_changed?
  end
end
