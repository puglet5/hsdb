# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  bio                    :text
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null, indexed
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  id                     :bigint           not null, primary key
#  last_name              :string           not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  organization           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string           indexed
#  sign_in_count          :integer          default(0), not null
#  slug                   :string
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
class User < ApplicationRecord
  include ProcessImage
  include ArTransactionChanges

  extend FriendlyId

  rolify

  acts_as_favoritor

  devise :database_authenticatable, :registerable, :rememberable, :validatable, :trackable

  has_many :discussions, dependent: :nullify
  has_many :artworks, dependent: :nullify
  has_many :replies, through: :discussions
  has_many :samples, dependent: :nullify
  has_many :spectra, dependent: :nullify

  # rubocop:disable Rails/InverseOf
  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all
  # rubocop:enable Rails/InverseOf

  has_one_attached :avatar do |blob|
    blob.variant :small, resize: '50x50^', crop: '50x50+0+0', format: :jpg
    blob.variant :medium, resize: '100x100^', crop: '100x100+0+0', format: :jpg
  end

  has_settings do |s|
    s.key :pagination, defaults: { per: '10' }
    s.key :processing, defaults: { enabled: false }
    s.key :uploading,  defaults: { thumbnails: true }
    s.key :ui, defaults: { tooltips: true, breadcrumbs: true, dark: false }
  end

  validates :email, format: URI::MailTo::EMAIL_REGEXP
  validates :password, confirmation: true
  validates :first_name, :last_name, :email, presence: true
  validates :avatar, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'] }

  accepts_nested_attributes_for :roles,
                                allow_destroy: true

  friendly_id :full_name_slug, use: %i[slugged finders]

  after_commit -> { process_image self, avatar&.id }, on: %i[update], unless: -> { transaction_changed_attributes.keys == ['updated_at'] }

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

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end
end
