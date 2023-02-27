# frozen_string_literal: true

# == Schema Information
#
# Table name: replies
#
#  id            :bigint           not null, primary key
#  reply         :text             not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  discussion_id :integer          indexed
#  user_id       :integer          indexed
#  slug          :string
#
# Indexes
#
#  index_replies_on_discussion_id  (discussion_id)
#  index_replies_on_user_id        (user_id)
#
# Foreign Keys
#
#  replies_discussion_id_fk  (discussion_id => discussions.id)
#  replies_user_id_fk        (user_id => users.id)
#

RSpec.describe Reply, type: :model do
  let(:user) { create(:user) }
  let(:discussion) { create(:discussion) }

  let(:valid_attributes) do
    {
      'reply' => 'Test reply',
      'user_id' => user.id,
      'discussion_id' => discussion.id
    }
  end

  let(:invalid_attributes) do
    {
      'reply' => nil,
      'user_id' => user.id,
      'discussion_id' => discussion.id
    }
  end

  describe 'Field presence validations' do
    it 'is valid with valid attributes' do
      reply = described_class.new valid_attributes
      expect(reply).to be_valid
    end

    it 'is not valid without a reply' do
      reply = described_class.new invalid_attributes
      expect(reply).to_not be_valid
    end
  end

  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:discussion) }
  end

  describe 'validations' do
    it { should validate_presence_of(:reply) }
  end
end
