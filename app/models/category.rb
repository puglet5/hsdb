# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  id            :bigint           not null, primary key
#  category_name :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  discussion_id :integer          indexed
#  slug          :string
#  pinned        :boolean          default(FALSE)
#  lock_version  :integer
#
# Indexes
#
#  index_categories_on_discussion_id  (discussion_id)
#
class Category < ApplicationRecord
  include Authorship

  has_many :discussions, dependent: nil
  has_many :users, through: :discussions

  validates :category_name, presence: true

  resourcify

  extend FriendlyId
  friendly_id :category_name, use: %i[slugged finders]

  def should_generate_new_friendly_id?
    slug.blank? || category_name_changed?
  end
end
