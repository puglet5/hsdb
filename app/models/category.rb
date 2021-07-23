class Category < ApplicationRecord
  has_many :discussions
  has_many :users, through: :discussions

  resourcify
end
