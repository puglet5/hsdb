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
#
# Indexes
#
#  index_spectra_on_metadata   (metadata) USING gin
#  index_spectra_on_sample_id  (sample_id)
#  index_spectra_on_user_id    (user_id)
#
class Spectrum < RsdbRecord
  include Authorship
  include CustomValidations
  include ParseMetadata

  default_scope { order(created_at: :desc) }
  scope :by_status, ->(status) { where(status: status) }
  scope :by_format, ->(format) { where(format: format) }
  scope :by_range,  ->(range)  { where(range: range) }

  # dates are passed in ISO 8601 format, i.e. YYYY-MM-DD.
  scope :by_created_at_period, ->(start_date, end_date) { where('created_at BETWEEN ? and ?', start_date, end_date) }

  belongs_to :sample, inverse_of: :spectra
  belongs_to :user, inverse_of: :spectra

  enum status: { none: 0, successful: 1, pending: 2, ongoing: 3, error: 4, other: 5 }, _prefix: :processing, _default: :none

  enum range: { not_set: 0, vis: 1, ir: 2, uv: 3, other: 4 }, _default: :not_set

  enum format: { not_set: 0, csv: 1, imp: 2, spectable: 3, mon: 4, txt: 5, dat: 6, dpt: 7, other: 99 }, _default: :not_set, _suffix: :format

  enum category: { not_set: 0, xrf: 1, xrd: 2, ftir: 3, libs: 4, raman: 5, thz: 6, other: 99 }, _default: :not_set, _suffix: :type

  has_one_attached :file
  has_one_attached :processed_file
  has_one_attached :settings

  has_rich_text :description
  has_rich_text :equipment

  before_save -> { self.filename ||= file.filename }
  before_save { self.plain_text_description = description&.body&.to_plain_text }
  before_save { self.plain_text_equipment = equipment&.body&.to_plain_text }

  after_create :infer_format
  after_create :infer_category
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
    broadcast_update_to('processing', target: "spectrum_#{id}", partial: 'samples/spectrum_tab_frame', locals: { spectrum: self, sample: sample })
    broadcast_update_to('processing', target: "spectrum_#{id}_panel", partial: 'samples/spectrum_panel_frame', locals: { spectrum: self, sample: sample })
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
    return unless file.attached?

    file_format = file.filename.to_s.split('.').last
    case file_format
    when 'dat'
      xrf_type!
    when 'dpt'
      ftir_type!
    else
      other_type!
    end
  end

  def request_processing(initiator)
    SendProcessingRequestJob.perform_later initiator
  end
end
