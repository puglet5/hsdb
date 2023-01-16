# frozen_string_literal: true

# == Schema Information
#
# Table name: styles
#
#  id         :bigint           not null, primary key
#  name       :string           indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_styles_on_name  (name) UNIQUE
#

RSpec.describe Style, type: :model do
  describe 'associations' do
    subject { Material.new(name: 'Test Material') }

    it { should have_many(:artworks) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
