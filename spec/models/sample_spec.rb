# frozen_string_literal: true

# == Schema Information
#
# Table name: samples
#
#  cas_name               :string
#  cas_no                 :string
#  category               :integer          default("not_set"), not null
#  color                  :string
#  common_names           :string
#  compound               :string
#  created_at             :datetime         not null
#  formula                :string
#  id                     :bigint           not null, primary key
#  is_reference           :boolean          default(FALSE), not null
#  location               :string
#  lock_version           :integer
#  metadata               :jsonb            not null, indexed
#  origin                 :string           default(""), not null
#  owner                  :string           default(""), not null
#  plain_text_description :text
#  sku                    :string           indexed
#  slug                   :string
#  survey_date            :date
#  title                  :string           not null
#  updated_at             :datetime         not null
#  user_id                :integer
#
# Indexes
#
#  index_samples_on_metadata  (metadata) USING gin
#  index_samples_on_sku       (sku)
#
RSpec.describe Sample, type: :model do
  let(:user) { create(:user) }

  let(:valid_attributes) do
    { 'title' => 'Test sample',
      'user_id' => user.id,
      'metadata' => '{}' }
  end

  let(:valid_sample) { build(:sample, user: user) }

  before(:each) do
    valid_sample.images.delete_all
    valid_sample.documents.delete_all
    valid_sample.spectra.delete_all
  end

  describe 'Field presence validations' do
    it 'is valid with valid attributes' do
      sample = described_class.new valid_attributes
      expect(sample).to be_valid
    end

    it 'is not valid without a title' do
      sample = described_class.new(title: nil)
      expect(sample).to_not be_valid
    end

    it 'has an existing associated user' do
      expect(valid_sample.user_id).not_to eq(nil)
    end

    it 'has a parsed metadata' do
      valid_sample.save!
      expect(valid_sample.metadata).to be_a(Hash).or eq('{}')
    end

    it 'has no attachments by default' do
      valid_sample.save!
      expect(valid_sample.images.any?).to eq(false)
      expect(valid_sample.spectra.any?).to eq(false)
    end
  end

  describe 'ActiveStorage attachment type validations' do
    shared_examples 'single image of valid types' do |filetype|
      it "accepts image/#{filetype}" do
        valid_sample.images.attach(io: File.open(file_fixture("test.#{filetype}")), filename: "test.#{filetype}", content_type: "image/#{filetype}")
        valid_sample.save!
        expect(valid_sample.errors.messages[:images]).to eq []
        expect(valid_sample.images.count).to eq(1)
        expect(valid_sample.images.first.persisted?).to eq(true)
      end
    end

    include_examples 'single image of valid types', 'jpeg'
    include_examples 'single image of valid types', 'png'
    include_examples 'single image of valid types', 'gif'

    context 'multiple images of valid types' do
      it 'accepts 2 jpeg images to images field' do
        2.times do
          valid_sample.images.attach(io: File.open(file_fixture('test.jpeg')), filename: 'test.jpeg', content_type: 'image/jpeg')
        end
        expect(valid_sample.images.count).to eq(2)
      end
    end

    context 'invalid files and file types' do
      it 'doesn\'t accept image/tiff to images field' do
        valid_sample.images.attach(io: File.open(file_fixture('test.tiff')), filename: 'test.tiff', content_type: 'image/tiff')
        valid_sample.save
        expect(valid_sample.errors.messages[:images]).to eq ['is not a valid file format']
        expect(valid_sample.images.first.persisted?).to eq(false)
      end
      it 'doesn\'t accept text/csv to images field' do
        valid_sample.images.attach(io: File.open(file_fixture('test.csv')), filename: 'test.csv', content_type: 'text/csv')
        valid_sample.save
        expect(valid_sample.errors.messages[:images]).to eq ['is not a valid file format']
        expect(valid_sample.images.first.persisted?).to eq(false)
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
  end
end
