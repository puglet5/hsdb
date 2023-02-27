# frozen_string_literal: true

# == Schema Information
#
# Table name: spectra
#
#  id                     :bigint           not null, primary key
#  format                 :integer          default("not_set"), not null
#  status                 :integer          default("none"), not null
#  category               :integer          default("not_set"), not null
#  sample_id              :bigint           not null, indexed
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  range                  :integer          default("not_set"), not null
#  metadata               :jsonb            not null, indexed
#  filename               :string
#  user_id                :bigint           not null, indexed
#  plain_text_description :text
#  plain_text_equipment   :text
#  task_id                :string
#
# Indexes
#
#  index_spectra_on_metadata   (metadata) USING gin
#  index_spectra_on_sample_id  (sample_id)
#  index_spectra_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (sample_id => samples.id)
#
RSpec.describe Spectrum, type: :model do
  let(:user) { create(:user) }
  let(:sample) { create(:sample) }

  let(:valid_attributes) do
    { 'sample_id' => sample.id,
      'user_id' => user.id,
      'metadata' => '{}' }
  end

  let(:valid_spectrum) { build(:spectrum, user: user, sample: sample) }

  before(:each) do
    valid_spectrum.file.delete
    valid_spectrum.processed_file.delete
    valid_spectrum.settings.delete
  end

  describe 'Field presence validations' do
    it 'is valid with valid attributes' do
      spectrum = described_class.new valid_attributes
      expect(spectrum).to be_valid
    end

    it 'has an existing associated user' do
      expect(valid_spectrum.user_id).not_to eq(nil)
    end

    it 'has a parsed metadata' do
      valid_spectrum.save!
      expect(valid_spectrum.metadata).to be_a(Hash)
    end

    it 'has no attachments by default' do
      valid_spectrum.save!
      expect(valid_spectrum.file.attached?).to eq(false)
      expect(valid_spectrum.processed_file.attached?).to eq(false)
      expect(valid_spectrum.settings.attached?).to eq(false)
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:sample) }
  end
end
