# frozen_string_literal: true

# == Schema Information
#
# Table name: artwork_tags
#
#  artwork_id :bigint           not null, indexed, indexed => [tag_id]
#  created_at :datetime         not null
#  id         :bigint           not null, primary key
#  tag_id     :bigint           not null, indexed => [artwork_id], indexed
#  updated_at :datetime         not null
#
# Indexes
#
#  index_artwork_tags_on_artwork_id             (artwork_id)
#  index_artwork_tags_on_artwork_id_and_tag_id  (artwork_id,tag_id) UNIQUE
#  index_artwork_tags_on_tag_id                 (tag_id)
#
# Foreign Keys
#
#  fk_rails_6e260d7103  (tag_id => tags.id)
#  fk_rails_f3f5e51fc4  (artwork_id => artworks.id)
#
class ArtworkTag < ApplicationRecord
  belongs_to :artwork
  belongs_to :tag
end
