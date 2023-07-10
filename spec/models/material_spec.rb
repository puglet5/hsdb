# frozen_string_literal: true

# == Schema Information
#
# Table name: materials
#
#  created_at :datetime         not null
#  id         :bigint           not null, primary key
#  name       :string           not null, indexed
#  updated_at :datetime         not null
#
# Indexes
#
#  index_materials_on_name  (name) UNIQUE
#
RSpec.describe Material, type: :model do
  let(:valid_attributes) do
    {
      'name' => 'Test Name'
    }
  end

  describe 'field presence validations' do
    it 'is valid with valid attributes' do
      material = described_class.new valid_attributes
      expect(material).to be_valid
    end
  end

  describe 'associations' do
    it { should have_many(:artwork_materials) }
    it { should have_many(:artworks) }
  end

  describe 'validations' do
    subject { Material.new(name: 'Test Material') }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
