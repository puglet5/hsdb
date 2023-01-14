# frozen_string_literal: true

# == Schema Information
#
# Table name: artwork_tags
#
#  id         :bigint           not null, primary key
#  artwork_id  :bigint           not null
#  tag_id     :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ArtworkTag < ApplicationRecord
  belongs_to :artwork
  belongs_to :tag
end
