# frozen_string_literal: true

require 'faraday'

class ProcessingRequestSender < ApplicationService
  URL = 'http://localhost:8000'

  attr_reader :record_id, :record_type

  def initialize(record_type, record_id)
    @record_type = record_type
    @record_id = record_id
  end

  def call
    request_url = "#{URL}/processing/#{@record_id}?record_type=#{record_type}"
    response = Faraday.post(request_url)
    handle_response(response)
  end

  private

  def handle_response(response)
    return unless response.status != 202

    Rails.logger.info(response.body)
  end
end
