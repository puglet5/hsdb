# frozen_string_literal: true

# == Schema Information
#
# Table name: styles
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe Style, type: :model do
  describe 'associations' do
    subject { Material.new(name: 'Test Material') }

    it { should have_many(:uploads) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
  end
end
