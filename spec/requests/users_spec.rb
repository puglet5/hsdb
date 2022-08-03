# frozen_string_literal: true

RSpec.describe '/users', type: :request do
  let(:user) { create(:user) }

  before :each do
    sign_in user
  end

  new_valid_settings = {
    'settings' => {
      'processing' => { 'enabled' => 'true' },
      'pagination' => { 'per' => '12' }
    }
  }

  new_invalid_settings = {
    'settings' => {
      'processing' => nil,
      'pagination' => nil
    }
  }

  describe 'GET /show' do
    it 'renders a successful response' do
      user.save!
      get user_url(id: user.id)
      expect(response).to be_successful
    end
  end

  describe 'PATCH /update_settings' do
    context 'with valid settings' do
      it 'updates the requested user with new settings' do
        user.save!
        patch update_settings_user_url(id: user.id), params: { user: new_valid_settings }
        user.reload
        expect(user.settings(:pagination).per).to eq('12')
        expect(user.settings(:processing).enabled).to eq('true')
      end

      it 'redirects to the user' do
        patch update_settings_user_url(id: user.id), params: { user: new_valid_settings }
        user.reload
        expect(response).to redirect_to(user_url(id: user.friendly_id))
      end
    end

    context 'with invalid settings' do
      it 'renders a successful response (i.e. to display the edit template with 422 response (turbo))' do
        user.save!
        patch update_settings_user_url(id: user.id), params: { user: new_invalid_settings }
        expect(response.status).to eq(302)
        user.reload
        expect(user.settings(:pagination).per).to eq('10')
        expect(user.settings(:processing).enabled).to eq('false')
      end
    end
  end
end
