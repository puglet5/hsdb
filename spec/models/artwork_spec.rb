# frozen_string_literal: true

# == Schema Information
#
# Table name: artworks
#
#  id           :bigint           not null, primary key
#  title        :string           not null
#  description  :text             not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer          indexed
#  slug         :string
#  status       :integer          default("draft")
#  metadata     :jsonb            not null, indexed
#  date         :string
#  survey_date  :date
#  style_id     :bigint           indexed
#  lock_version :integer
#
# Indexes
#
#  index_artworks_on_metadata  (metadata) USING gin
#  index_artworks_on_style_id  (style_id)
#  index_artworks_on_user_id   (user_id)
#
# Foreign Keys
#
#  artworks_user_id_fk  (user_id => users.id)
#  fk_rails_...         (style_id => styles.id)
#

RSpec.describe Artwork, type: :model do
  let(:user) { create(:user) }

  let(:valid_attributes) do
    { 'title' => 'Test described_class',
      'user_id' => user.id,
      'body' => '<p> test artwork body </p>',
      'description' => 'Test artwork description',
      'metadata' => '{}' }
  end

  let(:valid_artwork) { build(:artwork, user: user) }

  before(:each) do
    valid_artwork.images.delete_all
  end

  describe 'field presence validations' do
    it 'is valid with valid attributes' do
      artwork = described_class.new valid_attributes
      expect(artwork).to be_valid
    end

    it 'is not valid without a title' do
      artwork = described_class.new(title: nil, description: 'test description', body: 'test body')
      expect(artwork).to_not be_valid
    end

    it 'is not valid without a description' do
      artwork = described_class.new(title: 'test title', description: nil, body: 'test body')
      expect(artwork).to_not be_valid
    end

    it 'is not valid without a body' do
      artwork = described_class.new(title: 'test title', description: 'test description', body: nil)
      expect(artwork).to_not be_valid
    end

    it 'has an existing associated user' do
      expect(valid_artwork.user_id).not_to eq(nil)
    end

    it 'has a parsed metadata' do
      valid_artwork.save!
      expect(valid_artwork.metadata).to be_a(Hash).or eq('{}')
    end

    it 'has a default status of draft' do
      valid_artwork.save!
      expect(valid_artwork.status).to eq('draft')
    end

    it 'has no attachments by default' do
      valid_artwork.save!
      expect(valid_artwork.images.any?).to eq(false)
      expect(valid_artwork.thumbnail.attached?).to eq(false)
      expect(valid_artwork.documents.any?).to eq(false)
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:style).optional }

    it { should have_many(:images) }
    it { should have_many(:image_attachments) }
    it { should have_many(:materials) }
    it { should have_many(:artwork_materials) }
    it { should accept_nested_attributes_for(:images) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end
end
