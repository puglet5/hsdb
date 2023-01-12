# frozen_string_literal: true

# == Schema Information
#
# Table name: samples
#
#  id                :bigint           not null, primary key
#  title             :string           not null
#  user_id           :integer
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  metadata          :jsonb            not null
#  processing_status :integer          default(0)
#  category          :integer          default("not_set"), not null
#  origin            :string           default(""), not null
#  owner             :string           default(""), not null
#  sku               :string
#  cas_no            :string
#  cas_name          :string
#  common_names      :string
#  compound          :string
#  color             :string
#  formula           :string
#  location          :string
#  survey_date       :date
#  lock_version      :integer
#
class SampleSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  class UserSerializer < ActiveModel::Serializer
    attributes :id, :email, :first_name, :last_name
  end

  attributes :id, :title, :sku, :metadata, :processing_status, :category, :origin, :owner, :compound, :survey_date
  has_many :spectra, key: :spectra_count do
    object.spectra.count
  end

  has_many :documents, key: :documents_count do
    object.documents.count
  end

  has_many :images, key: :images_count do
    object.images.count
  end

  belongs_to :user, serializer: UserSerializer
end
