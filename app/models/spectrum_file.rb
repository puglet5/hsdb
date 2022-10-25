# frozen_string_literal: true

class SpectrumFile < RsdbRecord
  include PublicActivity::Model
  include Authorship
  include CustomValidations
  include ParseJson

  belongs_to :spectrum, inverse_of: :spectrum_files, touch: true

  enum status: { none: 0, successful: 1, pending: 2, ongoing: 3, error: 4, mixed: 5 }, _prefix: :processing, _default: :none
  enum range: { not_set: 0, vis: 1, ir: 2, uv: 3, other: 4 }, _default: :ir
  enum format: { not_set: 0, csv: 1, imp: 2, spectable: 3, mon: 4, txt: 5, dat: 6, other: 7 }, _default: :not_set, _suffix: :format
  enum category: { not_set: 0 }, _default: :not_set, _suffix: :category

  has_one_attached :file

  validates :file, blob: { content_type: %r{\Atext/.*\z} }
end
