# frozen_string_literal: true

# == Schema Information
#
# Table name: upload_tags
#
#  id         :bigint           not null, primary key
#  upload_id  :bigint           not null
#  tag_id     :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe UploadTag, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
