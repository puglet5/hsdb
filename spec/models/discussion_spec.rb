# frozen_string_literal: true

# == Schema Information
#
# Table name: discussions
#
#  category_id  :integer          default(2), indexed
#  content      :text
#  created_at   :datetime         not null
#  id           :bigint           not null, primary key
#  lock_version :integer
#  pinned       :boolean          default(FALSE)
#  slug         :string
#  title        :string           not null
#  updated_at   :datetime         not null
#  user_id      :integer          indexed
#
# Indexes
#
#  index_discussions_on_category_id  (category_id)
#  index_discussions_on_user_id      (user_id)
#
# Foreign Keys
#
#  discussions_category_id_fk  (category_id => categories.id)
#  discussions_user_id_fk      (user_id => users.id)
#
RSpec.describe Discussion, type: :model do
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  let(:valid_attributes) do
    {
      'title' => 'Test Title',
      'content' => 'Test content',
      'user_id' => user.id,
      'category_id' => category.id
    }
  end

  describe 'field presence validations' do
    it 'is valid with valid attributes' do
      discussion = described_class.new valid_attributes
      expect(discussion).to be_valid
    end

    it 'is not valid without a title' do
      discussion = described_class.new(title: nil, content: 'test content')
      expect(discussion).to_not be_valid
    end

    it 'is not valid without a content' do
      discussion = described_class.new(title: 'test title', content: nil)
      expect(discussion).to_not be_valid
    end

    it 'is not valid without a category_id' do
      discussion = described_class.new(category_id: nil)
      expect(discussion).to_not be_valid
    end
  end

  describe 'default field values' do
    it 'is expected to have a defaut category_id' do
      discussion = described_class.new(title: 'test title', content: 'test content')
      expect(discussion.category_id).to_not be_nil
    end

    it 'is not pinned by default' do
      discussion = described_class.new(title: 'test title', content: 'test content')
      expect(discussion.pinned).to eq(false)
    end
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:category) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
  end
end
