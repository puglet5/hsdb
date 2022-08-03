# frozen_string_literal: true

fdescribe ReplyPolicy do
  let(:reply) { build(:reply, user: user) }

  subject { described_class.new(user, reply) }

  context 'unauthorized' do
    let(:user) { nil }

    it 'expects user to be nil' do
      expect(user).to be_nil
    end

    it { is_expected.to permit_actions(%i[show]) }
    it { is_expected.to forbid_actions(%i[create update destroy]) }
  end

  context 'authorized, default role, not an author' do
    let(:user) { create(:default_user) }
    let(:another_user) { create(:default_user) }
    subject { described_class.new(another_user, reply) }

    it 'expects user not to be nil' do
      expect(another_user).to_not be_nil
    end

    it 'expects user to have a default role' do
      expect(another_user.has_role?(:default)).to eq(true)
    end

    it 'expects user not to be an author' do
      expect(another_user.author?(reply)).to eq(false)
    end

    it { is_expected.to permit_actions(%i[create show]) }
    it { is_expected.to forbid_actions(%i[destroy update]) }
  end

  context 'authorized, default role, is an author' do
    let(:user) { create(:default_user) }
    subject { described_class.new(user, reply) }

    it 'expects user not to be nil' do
      expect(user).to_not be_nil
    end

    it 'expects user to have a default role' do
      expect(user.has_role?(:default)).to eq(true)
    end

    it 'expects user to be an author' do
      expect(user.author?(reply)).to eq(true)
    end

    it { is_expected.to permit_actions(%i[create update destroy show]) }
  end

  context 'authorized, admin' do
    let(:user) { create(:default_user) }
    let(:admin) { create(:admin_user) }
    subject { described_class.new(user, reply) }

    it 'expects user not to be nil' do
      expect(user).to_not be_nil
    end

    it 'expects user to have a admin role' do
      expect(admin.has_role?(:admin)).to eq(true)
    end

    it 'expects user not to be an author' do
      expect(admin.author?(reply)).to eq(false)
    end

    it { is_expected.to permit_actions(%i[create update destroy show]) }
  end
end
