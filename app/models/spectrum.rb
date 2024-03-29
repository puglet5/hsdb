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
#  processing_message     :text
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
require 'rchardet'

class Spectrum < RsdbRecord
  include Authorship
  include CustomValidations
  include ParseMetadata

  AXES_SPEC = {
    not_set: { columnAxisType: 'xy', spectroscopyMethod: 'not_set', axesLabels: ['', ''], xAxisReverse: false, peakLabelPrecision: 0, yAxisMin: 0 },
    xrf: { columnAxisType: 'xy', spectroscopyMethod: 'xrf', axesLabels: ['Energy, keV', 'Intensity, a.u.'], xAxisReverse: false, peakLabelPrecision: 2, yAxisMin: 0 },
    xrd: { columnAxisType: 'xy', spectroscopyMethod: 'xrd', axesLabels: ['2Theta, degrees', 'Intensity, a.u.'], xAxisReverse: false, peakLabelPrecision: 2, yAxisMin: 0 },
    ftir: { columnAxisType: 'xy', spectroscopyMethod: 'ftir', axesLabels: ['Wavenumber, 1/cm', 'Intensity, a.u.'], xAxisReverse: true, peakLabelPrecision: 0, yAxisMin: 0 },
    libs: { columnAxisType: 'xy', spectroscopyMethod: 'libs', axesLabels: ['Wavelength, nm', 'Intensity, a.u.'], xAxisReverse: false, peakLabelPrecision: 0, yAxisMin: 0 },
    raman: { columnAxisType: 'xy', spectroscopyMethod: 'raman', axesLabels: ['Raman shift, 1/cm', 'Intensity, a.u.'], xAxisReverse: false, peakLabelPrecision: 0, yAxisMin: 0 },
    thz: { columnAxisType: 'xyyxy', spectroscopyMethod: 'thz', axesLabels: ['Frequency, THz', 'Intensity, a.u.'], xAxisReverse: false, peakLabelPrecision: 2, yAxisMin: nil },
    reflectance: { columnAxisType: 'xy', spectroscopyMethod: 'reflectance', axesLabels: ['Wavelength, nm', 'Reflectance, %'], xAxisReverse: false, peakLabelPrecision: 0, yAxisMin: 0 },
    other: { columnAxisType: 'xy', spectroscopyMethod: 'other', axesLabels: ['', ''], reverse: false, peakLabelPrecision: 0, yAxisMin: nil }
  }.freeze

  HEADER_MATCH_TABLE = {
    libs_spectable: {
      regex_lines: [
        Regexp.new("^Wavelenght[ \t]+Spectrum$"),
        Regexp.new("^Integration delay[ \t]+[+-]?([0-9]*[,])?[0-9]+$"),
        Regexp.new("^[+-]?([0-9]*[,])?[0-9]+\t[+-]?([0-9]*[,])?[0-9]+$")
      ]
    },
    libs_spec: {
      regex_lines: [
        Regexp.new('^[0-9]+$'),
        Regexp.new('^[0-9]+$'),
        Regexp.new("^[+-]?([0-9]*[,])?[0-9]+[ \t]+[+-]?([0-9]*[,])?[0-9]+$")
      ]
    },
    reflectance_mon: {
      regex_lines: [Regexp.new('^//Монохроматор: результаты регистрации$'.force_encoding(Encoding::UTF_8), Regexp::FIXEDENCODING)]
    },
    reflectance_csv: {
      regex_lines: [
        Regexp.new('^nm; ((%R)|A)$'),
        Regexp.new('[+-]?([0-9]*[,])?[0-9]+; [+-]?([0-9]*[,])?[0-9]+'),
        Regexp.new('[+-]?([0-9]*[,])?[0-9]+; [+-]?([0-9]*[,])?[0-9]+')
      ]
    },
    raman_txt: {
      regex_lines: [Regexp.new("^[+-]?([0-9]*[.])?[0-9]+[\t][+-]?([0-9]*[.])?[0-9]+$")]
    },
    ftir_dpt: {
      regex_lines: [Regexp.new('^[+-]?([0-9]*[.])?[0-9]+[,][+-]?([0-9]*[.])?[0-9]+$')]
    },
    xrd_txt: {
      regex_lines: [
        Regexp.new('^[+-]?([0-9]*[.])?[0-9]+ +[0-9]+$'),
        Regexp.new('^[+-]?([0-9]*[.])?[0-9]+ +[0-9]+$'),
        Regexp.new('^[+-]?([0-9]*[.])?[0-9]+ +[0-9]+$')
      ]
    },
    xrf_txt: {
      regex_lines: [
        Regexp.new("^[+-]?([0-9]*[.])?[0-9]+\t +[+-]?([0-9]*[.])?[0-9]+$"),
        Regexp.new("^[+-]?([0-9]*[.])?[0-9]+\t +[+-]?([0-9]*[.])?[0-9]+$"),
        Regexp.new("^[+-]?([0-9]*[.])?[0-9]+\t +[+-]?([0-9]*[.])?[0-9]+$")
      ]
    },
    xrf_dat: {
      regex_lines: [
        Regexp.new('^[+-]?([0-9]*[.])?[0-9]+ [+-]?([0-9]*[.])?[0-9]+$'),
        Regexp.new('^[0-9]+$'),
        Regexp.new('^[0-9]+$')
      ]
    },
    xrd_xy: {
      regex_lines: [
        Regexp.new('^[+-]?([0-9]*[.])?[0-9]+ [+-]?([0-9]*[.])?[0-9]+$'),
        Regexp.new('^[+-]?([0-9]*[.])?[0-9]+ [+-]?([0-9]*[.])?[0-9]+$'),
        Regexp.new('^[+-]?([0-9]*[.])?[0-9]+ [+-]?([0-9]*[.])?[0-9]+$')
      ]
    },
    thz_txt: {
      regex_lines: [
        Regexp.new("^[+-]?([0-9]*[,])?[0-9]+\t[+-]?([0-9]*[,])?[0-9]+$"),
        Regexp.new("^[+-]?([0-9]*[,])?[0-9]+\t[+-]?([0-9]*[,])?[0-9]+$"),
        Regexp.new("^[+-]?([0-9]*[,])?[0-9]+\t[+-]?([0-9]*[,])?[0-9]+$")
      ]
    }
  }.freeze

  default_scope { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }
  scope :by_format, ->(format) { where(format: format) }
  scope :by_type, ->(category) { where(category: category) }
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
  after_commit -> { infer_type }, on: %i[create], if: ->(s) { s.file.attached? && s.file.persisted? }

  after_commit :parse_metadata, on: %i[create update]
  after_commit :parse_processing_message, on: %i[update]
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

  def infer_type
    return unless file.attached? || !not_set_type?

    file_path = ActiveStorage::Blob.service.path_for(file.key)

    file_encoding = CharDet.detect(File.open(file_path, &:readline))['encoding']

    File.open(file_path, 'r', encoding: file_encoding) do |f|
      HEADER_MATCH_TABLE.stringify_keys.each do |k, v|
        res = v[:regex_lines].map { |r| r.match?(f.gets.strip) }
        if res.all?
          # rubocop:disable Rails/SkipsModelValidations
          update_column(:category, k.split('_')[0])
          # rubocop:enable Rails/SkipsModelValidations
          break
        end
        f.rewind
      end
    end
  end

  def parse_processing_message
    return unless processing_message

    parsed_message = processing_message.gsub!(/^"|"?$/, '')
    # rubocop:disable Rails/SkipsModelValidations
    update_column(:processing_message, parsed_message) if parsed_message
    # rubocop:enable Rails/SkipsModelValidations
  end

  def request_processing(initiator)
    SendProcessingRequestJob.perform_later initiator
  end
end
