# frozen_string_literal: true

module ParseJson
  extend ActiveSupport::Concern

  included do
    def parse_json
      parsed_json = JSON.parse(metadata.to_s) if metadata
      # rubocop:disable Rails/SkipsModelValidations
      update_column(:metadata, parsed_json) if parsed_json
      # rubocop:enable Rails/SkipsModelValidations
    rescue JSON::ParserError
      errors.add(:metadata, 'might not be a valid JSON object')
    end
  end
end
