# frozen_string_literal: true

# == Schema Information
#
# Table name: spectra
#
#  id         :bigint           not null, primary key
#  format     :integer          default("not_set"), not null
#  status     :integer          default("raw"), not null
#  category   :integer          default("not_set"), not null
#  sample_id  :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  range      :integer          default("ir"), not null
#  metadata   :jsonb            not null
#
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
