# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  first_name             :string           not null
#  last_name              :string
#  organization           :string
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  slug                   :string
#  bio                    :text

class User < ApplicationRecord
  extend FriendlyId
  rolify

  include PublicActivity::Model
  tracked owner: :itself

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :discussions, dependent: :nullify
  has_many :uploads, dependent: :nullify
  has_many :replies, through: :discussions
  has_many :spectra, dependent: :nullify
  has_one_attached :avatar

  has_settings do |s|
    s.key :pagination, defaults: { per: '10' }
    s.key :processing, defaults: { enabled: 'false' }
  end

  validates :password, confirmation: true
  validates :first_name, :last_name, :email, presence: true
  validates :avatar, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }

  accepts_nested_attributes_for :roles,
                                allow_destroy: true

  friendly_id :full_name_slug, use: %i[slugged finders]

  def full_name_slug
    "#{first_name} - #{last_name}"
  end

  def should_generate_new_friendly_id?
    slug.blank? || first_name_changed? || last_name_changed?
  end

  def guest?
    false
  end

  def author?(obj)
    obj.user == self
  end
end
