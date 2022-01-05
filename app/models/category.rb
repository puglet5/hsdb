# frozen_string_literal: true

class Category < ApplicationRecord
  has_many :discussions
  has_many :users, through: :discussions

  resourcify

  extend FriendlyId
  friendly_id :category_name, use: %i[slugged finders]

  def should_generate_new_friendly_id?
    category_name_changed?
  end
end
