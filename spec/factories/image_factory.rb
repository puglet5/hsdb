# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  id         :bigint           not null, primary key
#  artwork_id :bigint           not null, indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  range      :integer          default(0)
#  category   :integer          default("vis")
#  status     :integer          default("not_set")
#
# Indexes
#
#  index_images_on_artwork_id  (artwork_id)
#
# Foreign Keys
#
#  fk_rails_...  (artwork_id => artworks.id)
#
FactoryBot.define do
  factory :image do
    association :artwork, factory: :artwork, strategy: :build
  end
end
