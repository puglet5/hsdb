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
#  date        :string
#  survey_date :date
#  style_id    :bigint
#
class Upload < ApplicationRecord
  include PublicActivity::Model
  include Authorship
  include CustomValidations
  include ParseJson

  # include Elasticsearch::Model
  # include Elasticsearch::Model::Callbacks

  tracked owner: proc { |controller, _model| controller.current_user }

  has_many :images, inverse_of: :upload, dependent: :destroy
  accepts_nested_attributes_for :images, reject_if: proc { |attributes| attributes['image'].blank? }
  has_many :image_attachments, through: :images, dependent: :destroy

  has_one_attached :thumbnail do |blob|
    blob.variant :thumbnail, resize: '400x300^', crop: '400x300+0+0', format: :jpg
  end

  has_many_attached :documents

  has_many :upload_tags, dependent: :destroy
  has_many :tags, through: :upload_tags

  has_many :upload_materials, dependent: :destroy
  has_many :materials, through: :upload_materials

  belongs_to :style, optional: true, touch: true

  belongs_to :user
  validates :title, :description, presence: true
  validate :json_validity

  has_rich_text :body

  enum status: { draft: 0, active: 1, archived: 2 }

  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  after_commit :parse_json, on: %i[create update]
  after_commit :process_images, on: %i[create update]

  def should_generate_new_friendly_id?
    slug.blank? || title_changed?
  end

  def image_count
    images&.count.to_i
  end

  def has_images?
    image_count.positive?
  end

  private

  def process_images
    GenerateVariantsJob.perform_later id
  end
end
