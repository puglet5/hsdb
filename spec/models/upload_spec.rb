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

RSpec.describe Upload, type: :model do
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

  describe 'ActiveStorage attachment type validations' do
    shared_examples 'single image of valid types' do |filetype|
      it "accepts image/#{filetype}" do
        valid_upload.images.attach(io: File.open(file_fixture("test.#{filetype}")), filename: "test.#{filetype}", content_type: "image/#{filetype}")
        valid_upload.save!
        expect(valid_upload.errors.messages[:images]).to eq []
        expect(valid_upload.images.count).to eq(1)
        expect(valid_upload.images.first.persisted?).to eq(true)
      end
    end

    include_examples 'single image of valid types', 'jpeg'
    include_examples 'single image of valid types', 'png'
    include_examples 'single image of valid types', 'gif'

    context 'multiple images of valid types' do
      it 'accepts 2 jpeg images' do
        2.times do
          valid_upload.images.attach(io: File.open(file_fixture('test.jpeg')), filename: 'test.jpeg', content_type: 'image/jpeg')
        end
        expect(valid_upload.images.count).to eq(2)
      end
    end

    context 'invalid files and file types' do
      it 'doesn\'t accept image/tiff' do
        valid_upload.images.attach(io: File.open(file_fixture('test.tiff')), filename: 'test.tiff', content_type: 'image/tiff')
        valid_upload.save
        expect(valid_upload.errors.messages[:images]).to eq ['is not a valid file format']
        expect(valid_upload.images.first.persisted?).to eq(false)
      end
      it 'doesn\'t accept text/csv' do
        valid_upload.images.attach(io: File.open(file_fixture('test.csv')), filename: 'test.csv', content_type: 'text/csv')
        valid_upload.save
        expect(valid_upload.errors.messages[:images]).to eq ['is not a valid file format']
        expect(valid_upload.images.first.persisted?).to eq(false)
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:style).optional }

    it { should have_many(:materials) }
    it { should have_many(:upload_materials) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:body) }
    it { should validate_presence_of(:description) }
  end
end
