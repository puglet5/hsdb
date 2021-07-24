class User < ApplicationRecord
  rolify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable

  has_many :discussions, dependent: nil
  has_many :categories, through: :discussions

  extend FriendlyId
  friendly_id :last_name, use: [:slugged, :finders]

  def should_generate_new_friendly_id?
    last_name_changed?
  end
end
