class Upload < ApplicationRecord
  has_many_attached :images
  belongs_to :user
  validates :title, :description, presence: true
  validate :image_type

  def thumbnail(input)
    return self.images[input].variant(resize: "25%").processed
  end

  private

  def image_type
    images.each do |image|
      if !image.content_type.in?(%("image/jpeg image/png"))
        errors.add(:images, "need to be JPEG or PNG")
      end
    end
  end
end
