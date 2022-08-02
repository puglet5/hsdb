# frozen_string_literal: true

module CustomValidations
  extend ActiveSupport::Concern

  included do
    def json_validity
      errors.add(:metadata, 'is not a valid JSON object') unless JSON.is_json?(metadata)
    end
  end
end
