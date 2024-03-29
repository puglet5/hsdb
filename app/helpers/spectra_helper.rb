# frozen_string_literal: true

module SpectraHelper
  HUMANIZED_CATEGORIES_COLLECTION = Spectrum.categories.keys.map { |s| [ApplicationHelper.humanize_category(s), s] }
  HUMANIZED_RANGES_COLLECTION = Spectrum.ranges.keys.map { |s| [ApplicationHelper.humanize_range(s), s] }
  HUMANIZED_FORMATS_COLLECTION = Spectrum.formats.keys.map { |s| [ApplicationHelper.humanize_file_format(s), s] }
end
