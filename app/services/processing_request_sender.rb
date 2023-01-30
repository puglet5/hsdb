# frozen_string_literal: true

require 'faraday'

class ProcessingRequestSender < ApplicationService
  URL = 'http://localhost:8000'

  attr_reader :record_id, :record_type

  def initialize(record_type, record_id)
    @record_type = record_type.downcase
    @record_id = record_id
    @record = (Object.const_get record_type).find record_id
  end

  def call
    @record.processing_pending!
    request_url = "#{URL}/processing/#{@record_id}?record_type=#{record_type}"
    begin
      response = Faraday.post(request_url)
      handle_response(response)
    rescue Faraday::ConnectionFailed => e
      Rails.logger.error("Server connection failed for #{@record_type} with id #{@record_id}: #{e}")
      @record.processing_error!
    end
  end

  private

  def handle_response(response)
    return unless response.status != 202

    @record.processing_ongoing!
  end
end
