# frozen_string_literal: true

# == Schema Information
#
# Table name: categories
#
#  category_name :string           not null
#  created_at    :datetime         not null
#  discussion_id :integer          indexed
#  id            :bigint           not null, primary key
#  lock_version  :integer
#  pinned        :boolean          default(FALSE)
#  slug          :string
#  updated_at    :datetime         not null
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
