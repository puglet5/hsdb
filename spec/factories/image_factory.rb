# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  artwork_id :bigint           not null, indexed
#  category   :integer          default("vis")
#  created_at :datetime         not null
#  id         :bigint           not null, primary key
#  range      :integer          default(0)
#  status     :integer          default("not_set")
#  updated_at :datetime         not null
#
# Indexes
#
#  index_images_on_artwork_id  (artwork_id)
#
# Foreign Keys
#
#  fk_rails_54bb6d10ea  (artwork_id => artworks.id)
#
FactoryBot.define do
  factory :image do
    association :artwork, factory: :artwork, strategy: :build
  end
end
