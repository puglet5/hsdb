# frozen_string_literal: true

# == Schema Information
#
# Table name: uploads
#
#  id          :bigint           not null, primary key
#  title       :string           not null
#  description :text             not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :integer
#  slug        :string
#  status      :integer          default("draft")
#  metadata    :jsonb            not null
#  date        :string
#  survey_date :date
#  style_id    :bigint
#

RSpec.fdescribe Upload, type: :model do
  let(:user) { create(:user) }

  let(:valid_attributes) do
    { 'title' => 'Test described_class',
      'user_id' => user.id,
      'body' => '<p> test upload body </p>',
      'description' => 'Test upload description',
      'metadata' => '{}' }
  end

  let(:valid_upload) { build(:upload, user: user) }

  before(:each) do
    valid_upload.images.delete_all
  end

  describe 'field presence validations' do
    it 'is valid with valid attributes' do
      upload = described_class.new valid_attributes
      expect(upload).to be_valid
    end

    it 'is not valid without a title' do
      upload = described_class.new(title: nil, description: 'test description', body: 'test body')
      expect(upload).to_not be_valid
    end

    it 'is not valid without a description' do
      upload = described_class.new(title: 'test title', description: nil, body: 'test body')
      expect(upload).to_not be_valid
    end

    it 'is not valid without a body' do
      upload = described_class.new(title: 'test title', description: 'test description', body: nil)
      expect(upload).to_not be_valid
    end

    it 'has an existing associated user' do
      expect(valid_upload.user_id).not_to eq(nil)
    end

    it 'has a parsed metadata' do
      valid_upload.save!
      expect(valid_upload.metadata).to be_a(Hash).or eq('{}')
    end

    it 'has a default status of draft' do
      valid_upload.save!
      expect(valid_upload.status).to eq('draft')
    end

    it 'has no attachments by default' do
      valid_upload.save!
      expect(valid_upload.images.any?).to eq(false)
      expect(valid_upload.thumbnail.attached?).to eq(false)
      expect(valid_upload.documents.any?).to eq(false)
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:style).optional }

    it { should have_many(:images) }
    it { should have_many(:image_attachments) }
    it { should have_many(:materials) }
    it { should have_many(:upload_materials) }
    it { should accept_nested_attributes_for(:images) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
  end
end
