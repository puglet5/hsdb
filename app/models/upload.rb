# frozen_string_literal: true

# == Schema Information
#
# Table name: uploads
#
#  id          :bigint           not null, primary key
#  title       :string           not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  slug        :string
#  status      :integer          default("draft")
#  metadata    :jsonb            not null
#
class Upload < ApplicationRecord
  include PublicActivity::Model
  include Authorship
  include CustomValidations
  include ParseJson

  tracked owner: proc { |controller, _model| controller.current_user }

  has_many_attached :images
  has_one_attached :thumbnail
  has_many_attached :documents
  has_many :upload_tags, dependent: :destroy
  has_many :tags, through: :upload_tags
  belongs_to :user
  validates :title, :description, :body, presence: true
  validates :images, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif'] }
  validate :json_validity

  has_rich_text :body

  enum status: { draft: 0, active: 1, archived: 2 }

  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  after_commit :parse_json, on: %i[create update]
  after_commit do
    GenerateVariantsJob.perform_later id
  end

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end
end
