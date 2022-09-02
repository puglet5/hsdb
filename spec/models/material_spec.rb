# frozen_string_literal: true

# == Schema Information
#
# Table name: materials
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

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
    it { should have_many(:upload_materials) }
    it { should have_many(:uploads) }
  end

  describe 'validations' do
    subject { Material.new(name: 'Test Material') }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
