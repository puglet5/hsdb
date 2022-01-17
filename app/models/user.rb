# frozen_string_literal: true

class User < ApplicationRecord
  extend FriendlyId
  rolify
  # validate :must_have_a_role

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :discussions, dependent: :nullify
  has_many :uploads, dependent: :nullify
  has_many :categories, through: :discussions
  has_one_attached :avatar

  validates :password, confirmation: true

  after_create :assign_default_role

  accepts_nested_attributes_for :roles,
                                allow_destroy: true

  def assign_default_role
    add_role(:default) if roles.blank?
  end

  friendly_id :full_name_slug, use: %i[slugged finders]

  def full_name_slug
    "#{first_name} - #{last_name}"
  end

  def should_generate_new_friendly_id?
    slug.blank? || first_name_changed? || last_name_changed?
  end

  private

  def must_have_a_role
    errors.add(:roles, 'must have at least one') unless roles.any?
  end
end
