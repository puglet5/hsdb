# frozen_string_literal: true

# == Schema Information
#
# Table name: spectra
#
#  id                :bigint           not null, primary key
#  title             :string           not null
#  user_id           :integer
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  metadata          :jsonb            not null
#  processing_status :integer          default("none")

RSpec.describe Spectrum, type: :model do
  let(:user) { create(:user) }

  let(:valid_attributes) do
    { 'title' => 'Test spectrum',
      'user_id' => user.id,
      'metadata' => '{}' }
  end

  let(:valid_spectrum) { build(:spectrum, user: user) }

  before(:each) do
    valid_spectrum.csvs.delete_all
    valid_spectrum.files.delete_all
    valid_spectrum.images.delete_all
    valid_spectrum.processed_images.delete_all
    valid_spectrum.processed_csvs.delete_all
  end

  describe 'Field presence validations' do
    it 'is valid with valid attributes' do
      spectrum = described_class.new valid_attributes
      expect(spectrum).to be_valid
    end

    it 'is not valid without a title' do
      spectrum = described_class.new(title: nil)
      expect(spectrum).to_not be_valid
    end

    it 'has an existing associated user' do
      expect(valid_spectrum.user_id).not_to eq(nil)
    end

    it 'has a parsed metadata' do
      valid_spectrum.save!
      expect(valid_spectrum.metadata).to be_a(Hash).or eq('{}')
    end

    it 'has a default processing status of none' do
      valid_spectrum.save!
      expect(valid_spectrum.processing_status).to eq('none')
    end

    it 'has no attachments by default' do
      valid_spectrum.save!
      expect(valid_spectrum.images.any?).to eq(false)
      expect(valid_spectrum.csvs.attached?).to eq(false)
      expect(valid_spectrum.files.any?).to eq(false)
      expect(valid_spectrum.processed_csvs.attached?).to eq(false)
      expect(valid_spectrum.processed_images.any?).to eq(false)
    end
  end

  describe 'Processing status' do
    it 'changes enum status to successful' do
      valid_spectrum.processing_successful!
      expect(valid_spectrum.processing_status).to eq('successful')
    end

    it 'changes enum status to pending' do
      valid_spectrum.processing_pending!
      expect(valid_spectrum.processing_status).to eq('pending')
    end

    it 'changes enum status to none' do
      valid_spectrum.processing_none!
      expect(valid_spectrum.processing_status).to eq('none')
    end

    it 'changes enum status to error' do
      valid_spectrum.processing_error!
      expect(valid_spectrum.processing_status).to eq('error')
    end

    it 'changes enum status to mixed' do
      valid_spectrum.processing_mixed!
      expect(valid_spectrum.processing_status).to eq('mixed')
    end
  end

  describe 'ActiveStorage attachment type validations' do
    shared_examples 'single image of valid types' do |filetype|
      it "accepts image/#{filetype}" do
        valid_spectrum.images.attach(io: File.open(file_fixture("test.#{filetype}")), filename: "test.#{filetype}", content_type: "image/#{filetype}")
        valid_spectrum.save!
        expect(valid_spectrum.errors.messages[:images]).to eq []
        expect(valid_spectrum.images.count).to eq(1)
        expect(valid_spectrum.images.first.persisted?).to eq(true)
      end
    end

    include_examples 'single image of valid types', 'jpeg'
    include_examples 'single image of valid types', 'png'
    include_examples 'single image of valid types', 'gif'

    context 'multiple images of valid types' do
      it 'accepts 2 jpeg images to images field' do
        2.times do
          valid_spectrum.images.attach(io: File.open(file_fixture('test.jpeg')), filename: 'test.jpeg', content_type: 'image/jpeg')
        end
        expect(valid_spectrum.images.count).to eq(2)
      end

      it 'accepts 2 jpeg images to processed_images field' do
        2.times do
          valid_spectrum.images.attach(io: File.open(file_fixture('test.jpeg')), filename: 'test.jpeg', content_type: 'image/jpeg')
        end
        expect(valid_spectrum.images.count).to eq(2)
      end
    end

    context 'invalid files and file types' do
      it 'doesn\'t accept image/tiff to images field' do
        valid_spectrum.images.attach(io: File.open(file_fixture('test.tiff')), filename: 'test.tiff', content_type: 'image/tiff')
        valid_spectrum.save
        expect(valid_spectrum.errors.messages[:images]).to eq ['is not a valid file format']
        expect(valid_spectrum.images.first.persisted?).to eq(false)
      end
      it 'doesn\'t accept text/csv to images field' do
        valid_spectrum.images.attach(io: File.open(file_fixture('test.csv')), filename: 'test.csv', content_type: 'text/csv')
        valid_spectrum.save
        expect(valid_spectrum.errors.messages[:images]).to eq ['is not a valid file format']
        expect(valid_spectrum.images.first.persisted?).to eq(false)
      end

      it 'doesn\'t accept image/tiff to processed_images field' do
        valid_spectrum.processed_images.attach(io: File.open(file_fixture('test.tiff')), filename: 'test.tiff', content_type: 'image/tiff')
        valid_spectrum.save
        expect(valid_spectrum.errors.messages[:processed_images]).to eq ['is not a valid file format']
        expect(valid_spectrum.processed_images.first.persisted?).to eq(false)
      end
      it 'doesn\'t accept text/csv to processed_images field' do
        valid_spectrum.processed_images.attach(io: File.open(file_fixture('test.csv')), filename: 'test.csv', content_type: 'text/csv')
        valid_spectrum.save
        expect(valid_spectrum.errors.messages[:processed_images]).to eq ['is not a valid file format']
        expect(valid_spectrum.processed_images.first.persisted?).to eq(false)
      end
    end

    context 'files and csvs of valid types' do
      it 'accepts csv files to csvs field' do
        valid_spectrum.csvs.attach(io: File.open(file_fixture('test.csv')), filename: 'test.csv', content_type: 'text/csv')
        valid_spectrum.save!
        expect(valid_spectrum.errors.messages[:csvs]).to eq []
        expect(valid_spectrum.csvs.count).to eq(1)
        expect(valid_spectrum.csvs.first.persisted?).to eq(true)
      end

      it 'accepts csv files to processed_csvs field' do
        valid_spectrum.processed_csvs.attach(io: File.open(file_fixture('test.csv')), filename: 'test.csv', content_type: 'text/csv')
        valid_spectrum.save!
        expect(valid_spectrum.errors.messages[:processed_csvs]).to eq []
        expect(valid_spectrum.processed_csvs.count).to eq(1)
        expect(valid_spectrum.processed_csvs.first.persisted?).to eq(true)
      end

      it 'accepts any files to files field' do
        valid_spectrum.files.attach(io: File.open(file_fixture('test.csv')), filename: 'test.csv', content_type: 'text/csv')
        valid_spectrum.save!
        expect(valid_spectrum.errors.messages[:files]).to eq []
        expect(valid_spectrum.files.count).to eq(1)
        expect(valid_spectrum.files.first.persisted?).to eq(true)
      end
    end

    context 'csvs and processed_csvs of invalid types' do
      it 'doesn\'t accept non-csv files to csvs field' do
        valid_spectrum.csvs.attach(io: File.open(file_fixture('test.png')), filename: 'test.png', content_type: 'image/png')
        valid_spectrum.save
        expect(valid_spectrum.errors.messages[:csvs]).to eq ['is not a valid file format']
        expect(valid_spectrum.csvs.first.persisted?).to eq(false)
      end

      it 'doesn\'t accept non-csv files to processed_csvs field' do
        valid_spectrum.processed_csvs.attach(io: File.open(file_fixture('test.png')), filename: 'test.png', content_type: 'image/png')
        valid_spectrum.save
        expect(valid_spectrum.errors.messages[:processed_csvs]).to eq ['is not a valid file format']
        expect(valid_spectrum.processed_csvs.first.persisted?).to eq(false)
      end
    end
  end

  fdescribe 'Associations' do
    it { should belong_to(:user) }
  end
end