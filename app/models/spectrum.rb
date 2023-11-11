# frozen_string_literal: false

# == Schema Information
#
# Table name: spectra
#
#  category               :integer          default("not_set"), not null
#  created_at             :datetime         not null
#  filename               :string
#  format                 :integer          default("not_set"), not null
#  id                     :bigint           not null, primary key
#  is_reference           :boolean          default(FALSE)
#  metadata               :jsonb            not null, indexed
#  plain_text_description :text
#  plain_text_equipment   :text
#  range                  :integer          default("not_set"), not null
#  sample_id              :bigint           not null, indexed
#  sample_thickness       :float
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
class Spectrum < RsdbRecord
  include Authorship
  include CustomValidations
  include ParseMetadata

  AXES_SPEC = {
    not_set: { labels: ['', ''], reverse: false, peak_label_precision: 0, y_min: 0 },
    xrf: { labels: ['Energy, keV', 'Intensity, a.u.'], reverse: false, peak_label_precision: 2, y_min: 0 },
    xrd: { labels: ['2Theta, degrees', 'Intensity, a.u.'], reverse: false, peak_label_precision: 2, y_min: 0 },
    ftir: { labels: ['Wavenumber, 1/cm', 'Intensity, a.u.'], reverse: true, peak_label_precision: 0, y_min: 0 },
    libs: { labels: ['Wavelength, nm', 'Intensity, a.u.'], reverse: false, peak_label_precision: 0, y_min: 0 },
    raman: { labels: ['Raman shift, 1/cm', 'Intensity, a.u.'], reverse: false, peak_label_precision: 0, y_min: 0 },
    thz: { labels: ['Frequency, THz', 'Intensity, a.u.'], reverse: false, peak_label_precision: 2, y_min: nil },
    reflectance: { labels: ['Wavelength, nm', 'Reflectance, %'], reverse: false, peak_label_precision: 0, y_min: 0 },
    other: { labels: ['', ''], reverse: false }
  }.freeze

  HEADER_MATCH_TABLE = {
    xrf: { regex: Regexp.new('^.*[+-]?([0-9]*[.])?[0-9]+[ \t]+[+-]?([0-9]*[.])?[0-9]+.*$'), encoding: 'UTF-8' },
    ftir: { regex: Regexp.new('^.*[+-]?([0-9]*[.])?[0-9]+[,][+-]?([0-9]*[.])?[0-9]+.*$'), encoding: 'UTF-8' },
    libs: { regex: Regexp.new("^.*Wavelenght[ \t]+Spectrum.*$"), encoding: 'UTF-8' },
    raman: { regex: Regexp.new("^.*[+-]?([0-9]*[.])?[0-9]+[\t][+-]?([0-9]*[.])?[0-9]+.*$"), encoding: 'UTF-8' },
    reflectance: { regex: Regexp.new('^.*\/\/Монохроматор: результаты регистрации.*$'.force_encoding('UTF-8'), Regexp::FIXEDENCODING), encoding: 'Windows-1251' }
  }.freeze

  default_scope { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }
  scope :by_format, ->(format) { where(format: format) }
  scope :by_range,  ->(range)  { where(range: range) }
  scope :by_sample_id, ->(sample_id) { where(sample_id: sample_id) }

  # dates are passed in ISO 8601 format, i.e. YYYY-MM-DD.
  scope :by_created_at_period, ->(start_date, end_date) { where('created_at BETWEEN ? and ?', start_date, end_date) }

  belongs_to :sample, inverse_of: :spectra
  belongs_to :user, inverse_of: :spectra

  enum status: { none: 0, successful: 1, pending: 2, ongoing: 3, error: 4, other: 5 }, _prefix: :processing, _default: :none

  enum range: { not_set: 0, vis: 1, ir: 2, uv: 3, other: 4 }, _default: :not_set

  enum format: { not_set: 0, csv: 1, imp: 2, spectable: 3, mon: 4, txt: 5, dat: 6, dpt: 7, xy: 8, spec: 9, other: 99 }, _default: :not_set, _suffix: :format

  enum category: { not_set: 0, xrf: 1, xrd: 2, ftir: 3, libs: 4, raman: 5, thz: 6, reflectance: 7, other: 99 }, _default: :not_set, _suffix: :type

  has_one_attached :file
  has_one_attached :processed_file
  has_one_attached :settings

  has_rich_text :description
  has_rich_text :equipment

  before_save -> { self.filename ||= file.filename }
  before_save { self.plain_text_description = description&.body&.to_plain_text }
  before_save { self.plain_text_equipment = equipment&.body&.to_plain_text }

  after_create -> { infer_format }
  # after_commit -> { infer_category }, on: %i[create], if: ->(s) { s.file.attached? && s.file.persisted? }

  after_commit :parse_metadata, on: %i[create update]
  after_commit -> { request_processing self }, on: %i[create],
                                               if: lambda { |s|
                                                     s.file.attached? &&
                                                       s.file.persisted? &&
                                                       s.user.settings(:processing).enabled == true
                                                   }
  after_update_commit :broadcast_later

  private

  def broadcast_later
    broadcast_update_later_to('processing', target: "spectrum_#{id}", partial: 'samples/spectrum_processing_indicator_frame', locals: { spectrum: self, sample: sample })
    broadcast_update_later_to('processing', target: "spectrum_#{id}_request_processing_button", partial: 'samples/spectrum_request_processing_button_frame', locals: { spectrum: self, sample: sample })
    broadcast_update_later_to('processing', target: "spectrum_#{id}_chart_area", partial: 'samples/spectrum_chart_area_frame', locals: { spectrum: self, sample: sample })
  end

  def infer_format
    return unless file.attached?

    file_format = file.filename.to_s.split('.').last

    if Spectrum.formats.key? file_format
      update format: file_format
    else
      update format: 'other'
    end
  end

  def infer_category
    return unless file.attached? || !not_set_type?

    file_format = file.filename.to_s.split('.').last
    case file_format
    when 'dat'
      if valid_header?(file, :xrf)
        xrf_type!
      else
        other_type!
      end
    when 'dpt'
      if valid_header?(file, :ftir)
        ftir_type!
      else
        other_type!
      end
    when 'spectable'
      if valid_header?(file, :libs)
        libs_type!
      else
        other_type!
      end
    when 'spec'
      libs_type!
    when 'mon'
      if valid_header?(file, :reflectance)
        reflectance_type!
      else
        other_type!
      end
    when 'xy'
      xrd_type!
    when 'txt'
      if valid_header?(file, :raman)
        raman_type!
      elsif valid_header?(file, :xrf)
        xrf_type!
      else
        other_type!
      end
    when 'csv'
      not_set_type!
    else
      other_type!
    end
  end

  def valid_header?(file, acquisition_method)
    file_path = ActiveStorage::Blob.service.path_for(file.key)
    begin
      header = File.open(file_path, encoding: HEADER_MATCH_TABLE[acquisition_method][:encoding], &:readline)
    rescue StandardError
      false
    end

    begin
      HEADER_MATCH_TABLE[acquisition_method][:regex].match?(header)
    rescue StandardError
      false
    end
  end

  def request_processing(initiator)
    SendProcessingRequestJob.perform_later initiator
  end
end
