# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  bio                    :text
#  created_at             :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string
#  email                  :string           default(""), not null, indexed
#  encrypted_password     :string           default(""), not null
#  first_name             :string           not null
#  id                     :bigint           not null, primary key
#  last_name              :string           not null
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string
#  organization           :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string           indexed
#  sign_in_count          :integer          default(0), not null
#  slug                   :string
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
RSpec.describe User, type: :model do
  let(:valid_attributes) do
    { 'id' => '1',
      'first_name' => 'John',
      'last_name' => 'Smith',
      'organization' => 'test',
      'email' => 'test@example.com',
      'password' => '123456',
      'password_confirmation' => '123456' }
  end

  let(:valid_user) { build(:user) }

  describe 'Field presence validations' do
    it 'is valid with valid attributes' do
      user = described_class.new valid_attributes
      expect(user).to be_valid
    end

    it 'is not valid without a first_name' do
      user = described_class.new valid_attributes.merge(first_name: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid without a last_name' do
      user = described_class.new valid_attributes.merge(last_name: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid without a email' do
      user = described_class.new valid_attributes.merge(email: nil)
      expect(user).to_not be_valid
    end

    it 'is not valid without a password' do
      user = described_class.new valid_attributes.merge(password: nil)
      expect(user).to_not be_valid
    end

    it 'has no attachments by default' do
      valid_user.save!
      expect(valid_user.avatar.attached?).to eq(false)
    end

    it 'is not a guest' do
      expect(valid_user).to_not be_guest
    end

    it 'has no roles by default' do
      expect(valid_user.roles.count).to eq(0)
    end

    context 'default settings' do
      it 'has default settings for pagination' do
        expect(valid_user.settings(:pagination).per).to eq('10')
      end

      it 'has default settings for sample spectra processing' do
        expect(valid_user.settings(:processing).enabled).to eq(false)
      end

      it 'has default settings for image artworks' do
        expect(valid_user.settings(:uploading).thumbnails).to eq(true)
      end
    end
  end

  describe 'ActiveStorage avatar attachment' do
    context 'User' do
      it 'can have an avatar attached' do
        valid_user.avatar.attach(io: File.open(file_fixture('test.png')), filename: 'test.png', content_type: 'image/png')
        valid_user.save!
        expect(valid_user.errors.messages[:avatar]).to eq []
        expect(valid_user.avatar.persisted?).to eq(true)
      end
    end

    context 'Avatar' do
      it 'accepts image/png' do
        valid_user.avatar.attach(io: File.open(file_fixture('test.png')), filename: 'test.png', content_type: 'image/png')
        valid_user.save!
        expect(valid_user.errors.messages[:avatar]).to eq []
        expect(valid_user.avatar.attached?).to eq(true)
        expect(valid_user.avatar.persisted?).to eq(true)
      end

      it 'accepts image/jpeg' do
        valid_user.avatar.attach(io: File.open(file_fixture('test.jpeg')), filename: 'test.jpeg', content_type: 'image/jpeg')
        valid_user.save!
        expect(valid_user.errors.messages[:avatar]).to eq []
        expect(valid_user.avatar.attached?).to eq(true)
        expect(valid_user.avatar.persisted?).to eq(true)
      end

      it 'doesn\t accept non-valid image types' do
        valid_user.avatar.attach(io: File.open(file_fixture('test.tiff')), filename: 'test.tiff', content_type: 'image/tiff')
        valid_user.save
        expect(valid_user.errors.messages[:avatar]).to eq ['is not a valid file format']
        expect(valid_user.avatar.persisted?).to eq(false)
      end

      it 'doesn\t accept non-valid file types' do
        valid_user.avatar.attach(io: File.open(file_fixture('test.csv')), filename: 'test.csv', content_type: 'text/csv')
        valid_user.save
        expect(valid_user.errors.messages[:avatar]).to eq ['is not a valid file format']
        expect(valid_user.avatar.persisted?).to eq(false)
      end
    end
  end

  describe 'Associations' do
    it { should have_many(:samples) }
    it { should have_many(:spectra) }
    it { should have_many(:artworks) }
    it { should have_many(:replies).through(:discussions) }
    it { should have_many(:discussions) }
    it { should accept_nested_attributes_for(:roles) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end
end
