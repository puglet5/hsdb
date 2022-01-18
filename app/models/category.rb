# frozen_string_literal: true

class Category < ApplicationRecord
  include PublicActivity::Model
  include Authorship
  tracked

  has_many :discussions, dependent: nil
  has_many :users, through: :discussions

  resourcify

  extend FriendlyId
  friendly_id :category_name, use: %i[slugged finders]

  def should_generate_new_friendly_id?
    slug.blank? || category_name_changed?
  end
end
