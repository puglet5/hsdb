# frozen_string_literal: true

class Spectrum < RsdbRecord
  include PublicActivity::Model
  include Authorship

  tracked owner: proc { |controller, _model| controller.current_user }

  belongs_to :user
  validates :title, presence: true

  extend FriendlyId
  friendly_id :title, use: %i[slugged finders]
end
