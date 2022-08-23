# frozen_string_literal: true

class Style < ApplicationRecord
  has_many :uploads, dependent: nil

  validates :name, presence: true, uniqueness: true
end
