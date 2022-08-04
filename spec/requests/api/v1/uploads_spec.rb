# frozen_string_literal: true

require 'swagger_helper'

fdescribe Api::V1::UploadsController do
  describe 'GET #index' do
    context 'when unauthorized' do
      it 'fails with HTTP 401' do
        get '/api/v1/uploads'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized' do
      let(:application) { FactoryBot.create(:application) }
      let(:user)        { FactoryBot.create(:user) }
      let(:upload)      { FactoryBot.create(:upload, user: user) }
      let(:token)       { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }

      it 'succeeds' do
        upload.save!
        get '/api/v1/uploads', params: {}, headers: { Authorization: "Bearer #{token.token}" }
        expect(response).to be_successful
        expect(JSON.parse(response.body).first).to eq(JSON.parse(upload.to_json))
      end
      run_test!
    end
  end
end
