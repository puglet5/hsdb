require 'rails_helper'

RSpec.describe Upload, type: :model do
  let(:user) { create(:user) }

  let(:valid_attributes) do
    { 'title' => 'Test Upload',
      'user_id' => user.id,
      'metadata' => '{}',
      'status' => 'draft',
      'body' => '<p> test upload body </p>',
      'description' => 'Test upload description' }
  end

  fdescribe 'Presence validations' do
    it 'is valid with valid attributes' do
      upload = Upload.new valid_attributes
      expect(upload).to be_valid
    end

    it 'is not valid without a title' do
      upload = Upload.new(title: nil, description: 'test description', body: 'test body')
      expect(upload).to_not be_valid
    end

    it 'is not valid without a description' do
      upload = Upload.new(title: 'test title', description: nil, body: 'test body')
      expect(upload).to_not be_valid
    end

    it 'is not valid without a body' do
      upload = Upload.new(title: 'test title', description: 'test description', body: nil)
      expect(upload).to_not be_valid
    end
  end
end
