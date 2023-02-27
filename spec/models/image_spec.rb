# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  id         :bigint           not null, primary key
#  artwork_id :bigint           not null, indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  range      :integer          default(0)
#  category   :integer          default("vis")
#  status     :integer          default("not_set")
#
# Indexes
#
#  index_images_on_artwork_id  (artwork_id)
#
# Foreign Keys
#
#  fk_rails_...  (artwork_id => artworks.id)
#

RSpec.describe Image, type: :model do
  let(:artwork) { create(:artwork) }
  let(:valid_image) { build(:image, artwork: artwork) }

  describe 'ActiveStorage attachment type validations' do
    shared_examples 'single image of valid types' do |filetype|
      it "accepts image/#{filetype}" do
        valid_image.image.attach(io: File.open(file_fixture("test.#{filetype}")), filename: "test.#{filetype}", content_type: "image/#{filetype}")
        valid_image.save!
        expect(valid_image.errors.messages[:image]).to eq []
        expect(valid_image.image.attached?).to eq(true)
        expect(valid_image.image.persisted?).to eq(true)
      end
    end

    include_examples 'single image of valid types', 'jpeg'
    include_examples 'single image of valid types', 'png'
    include_examples 'single image of valid types', 'gif'

    context 'invalid files and file types' do
      it 'doesn\'t accept image/tiff' do
        valid_image.image.attach(io: File.open(file_fixture('test.tiff')), filename: 'test.tiff', content_type: 'image/tiff')
        valid_image.save
        expect(valid_image.errors.messages[:image]).to eq ['is not a valid file format']
        expect(valid_image.image.persisted?).to eq(false)
      end
      it 'doesn\'t accept text/csv' do
        valid_image.image.attach(io: File.open(file_fixture('test.csv')), filename: 'test.csv', content_type: 'text/csv')
        valid_image.save
        expect(valid_image.errors.messages[:image]).to eq ['is not a valid file format']
        expect(valid_image.image.persisted?).to eq(false)
      end
    end
  end

  describe 'associations' do
    it { should belong_to(:artwork) }
  end
end
