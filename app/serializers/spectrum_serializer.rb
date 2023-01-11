# frozen_string_literal: true

class SpectrumSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  def file_url
    rails_blob_path(object.file, only_path: true)
  end

  def filename
    object.file.filename
  end

  class SampleSerializer < ActiveModel::Serializer
    attributes :id, :title
  end

  attributes :id, :format, :status, :category, :range, :metadata
  attributes :file_url
  attributes :filename

  belongs_to :sample, serializer: SampleSerializer
end
