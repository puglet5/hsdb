# frozen_string_literal: true

# == Schema Information
#
# Table name: artwork_materials
#
#  id          :bigint           not null, primary key
#  artwork_id   :bigint           not null
#  material_id :bigint           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

RSpec.describe ArtworkMaterial, type: :model do
  describe 'associations' do
    it { should belong_to(:material) }
    it { should belong_to(:artwork) }
  end
end
