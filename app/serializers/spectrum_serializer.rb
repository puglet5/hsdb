# frozen_string_literal: true

# == Schema Information
#
# Table name: spectra
#
#  id         :bigint           not null, primary key
#  format     :integer          default("not_set"), not null
#  status     :integer          default("none"), not null
#  category   :integer          default("not_set"), not null
#  sample_id  :bigint           not null, indexed
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  range      :integer          default("not_set"), not null
#  metadata   :jsonb            not null, indexed
#  filename   :string
#  user_id    :bigint           not null, indexed
#
# Indexes
#
#  index_spectra_on_metadata   (metadata) USING gin
#  index_spectra_on_sample_id  (sample_id)
#  index_spectra_on_user_id    (user_id)
#
class SpectrumSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  def file_url
    return nil unless object.file.attached?

    rails_blob_path(object&.file, only_path: true)
  end

  def filename
    object&.file&.filename
  end

  class SampleSerializer < ActiveModel::Serializer
    attributes :id, :title
  end

  attributes :id, :format, :status, :category, :range, :metadata
  attributes :file_url
  attributes :filename

  belongs_to :sample, serializer: SampleSerializer
end
