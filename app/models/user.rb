# frozen_string_literal: true

class User < ApplicationRecord
  rolify

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :discussions, dependent: nil
  has_many :uploads, dependent: nil
  has_many :categories, through: :discussions
  has_one_attached :avatar

  extend FriendlyId
  friendly_id :full_name_slug, use: %i[slugged finders]

  def full_name_slug
    "#{first_name} - #{last_name}"
  end

  def should_generate_new_friendly_id?
    slug.blank? || last_name_changed? || last_name_changed?
  end
end
