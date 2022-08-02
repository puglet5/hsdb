# frozen_string_literal: true

module CustomValidations
  extend ActiveSupport::Concern

  included do
    def json_validity
      errors.add(:metadata, 'is not a valid JSON object') unless JSON.is_json?(metadata)
    end

    def parse_json
      parsed_json = JSON.parse(metadata.to_s) if metadata
      # rubocop:disable Rails/SkipsModelValidations
      update_column(:metadata, parsed_json) if parsed_json
      # rubocop:enable Rails/SkipsModelValidations
    rescue JSON::ParserError
      errors.add(:metadata, 'might not be a valid JSON object')
    end

    def csv_type
      csvs.each do |csv|
        unless csv.content_type.in?(%("text/csv"))
          errors.add(:csvs,
                     'need to be in a .csv file format')
        end
      end
    end

    def image_type
      images.each do |image|
        unless image.content_type.in?(%("image/jpeg image/png image/svg image/gif"))
          errors.add(:images,
                     'need to be in a specified file formats')
        end
      end
    end
  end
end
