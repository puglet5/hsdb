# frozen_string_literal: true

module SpectraHelper
  def self.humanize_file_format(str)
    return str.humanize if %w[other not_set].include? str

    ".#{str}"
  end

  def self.humanize_range(str)
    return str.humanize if %w[other not_set].include? str

    str.upcase
  end

  HUMANIZED_RANGES_COLLECTION = Spectrum.ranges.keys.map { |s| [humanize_range(s), s] }
  HUMANIZED_FORMATS_COLLECTION = Spectrum.formats.keys.map { |s| [humanize_file_format(s), s] }
end
