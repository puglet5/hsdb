# frozen_string_literal: true

require 'faraday'

class ProcessingRequestSender < ApplicationService
  URL = 'http://0.0.0.0:8000'

  attr_reader :record_id, :record_type

  def initialize(record_type, record_id)
    @record_type = record_type.downcase
    @record_id = record_id
    @record = (Object.const_get record_type).find record_id
  end

  def call
    return unless @record

    request_url = "#{URL}/processing/#{@record_id}?record_type=#{record_type}"
    @record.processing_pending!
    begin
      response = Faraday.post request_url
      handle_response response
    rescue Faraday::ConnectionFailed => e
      Rails.logger.error("Server connection failed for #{@record_type} with id #{@record_id}: #{e}")
      @record.processing_error!
    end
  end

  private

  def handle_response(response)
    unless response.success?
      @record.processing_error!
      return
    end

    response_body = JSON.parse response.body
    Rails.logger.info response_body

    task_id = response_body['task']['id']
    update_task_id task_id
  end

  def update_task_id(id)
    @record.update! task_id: id
  end
end
