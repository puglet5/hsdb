# frozen_string_literal: true

# == Schema Information
#
# Table name: artwork_tags
#
#  id         :bigint           not null, primary key
#  artwork_id :bigint           not null, indexed, indexed => [tag_id]
#  tag_id     :bigint           not null, indexed => [artwork_id], indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_artwork_tags_on_artwork_id             (artwork_id)
#  index_artwork_tags_on_artwork_id_and_tag_id  (artwork_id,tag_id) UNIQUE
#  index_artwork_tags_on_tag_id                 (tag_id)
#
class ArtworkTag < ApplicationRecord
  belongs_to :artwork
  belongs_to :tag
end
