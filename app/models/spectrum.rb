# frozen_string_literal: true

class Spectrum < RsdbRecord
  include PublicActivity::Model
  include Authorship

  tracked owner: proc { |controller, _model| controller.current_user }

  belongs_to :user
  has_many_attached :csvs
  has_many_attached :processed_csvs
  has_many_attached :documents
  has_many_attached :images
  has_many_attached :processed_images

  validates :title, presence: true
  # validate :csv_type
  validate :image_type

  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]

  private

  def csv_type
    csvs.each do |csv|
      unless csv.content_type.in?(%("text/csv"))
        errors.add(:csvs,
                   'need to be in a .csv file format')
      end
    end
  end

  def image_type
    images.each do |image|
      unless image.content_type.in?(%("image/jpeg image/png image/svg image/gif"))
        errors.add(:images,
                   'need to be in a specified file formats')
      end
    end
  end
end
