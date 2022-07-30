# frozen_string_literal: true

# == Schema Information
#
# Table name: spectra
#
#  id                :bigint           not null, primary key
#  title             :string           not null
#  user_id           :integer
#  slug              :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  metadata          :jsonb            not null
#  processing_status :integer          default("none")
#
require 'rails_helper'

RSpec.describe Spectrum, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
