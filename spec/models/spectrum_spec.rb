# frozen_string_literal: true

# == Schema Information
#
# Table name: spectra
#
#  category               :integer          default("not_set"), not null
#  created_at             :datetime         not null
#  filename               :string
#  format                 :integer          default("not_set"), not null
#  id                     :bigint           not null, primary key
#  metadata               :jsonb            not null, indexed
#  plain_text_description :text
#  plain_text_equipment   :text
#  range                  :integer          default("not_set"), not null
#  sample_id              :bigint           not null, indexed
#  status                 :integer          default("none"), not null
#  task_id                :string
#  updated_at             :datetime         not null
#  user_id                :bigint           default(1), not null, indexed
#
# Indexes
#
#  index_spectra_on_metadata   (metadata) USING gin
#  index_spectra_on_sample_id  (sample_id)
#  index_spectra_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_dfa20a7cb9  (sample_id => samples.id)
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

  describe 'Acquisition method inference' do
    let!(:xrf_txt_spectrum) { create(:spectrum, :with_file, file: 'xrf.txt') }
    let!(:xrf_dat_spectrum) { create(:spectrum, :with_file, file: 'xrf.dat') }
    let!(:ftir_dpt_spectrum) { create(:spectrum, :with_file, file: 'ftir.dpt') }
    let!(:raman_txt_spectrum) { create(:spectrum, :with_file, file: 'raman.txt') }
    let!(:libs_spectable_spectrum) { create(:spectrum, :with_file, file: 'libs.spectable') }
    it 'infers .txt XRF files' do
      expect(xrf_txt_spectrum.category).to eq('xrf')
    end

    it 'infers .dat XRF files' do
      expect(xrf_dat_spectrum.category).to eq('xrf')
    end

    it 'infers .dpt FTIR files' do
      expect(ftir_dpt_spectrum.category).to eq('ftir')
    end

    it 'infers .txt Raman files' do
      expect(raman_txt_spectrum.category).to eq('raman')
    end

    it 'infers .spectable LIBS files' do
      expect(libs_spectable_spectrum.category).to eq('libs')
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:sample) }
  end
end
