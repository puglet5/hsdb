class Discussion < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :replies, dependent: :destroy

  validates :title, :content, presence: true

  resourcify
end
