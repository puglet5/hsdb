# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::ArtworksController do
  describe 'GET #index' do
    context 'when unauthorized' do
      it 'fails with HTTP 401' do
        get '/api/v1/artworks'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized' do
      let(:application) { FactoryBot.create(:application) }
      let(:user)        { FactoryBot.create(:user) }
      let(:artwork) { FactoryBot.create(:artwork, user: user) }
      let(:token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }

      it 'succeeds' do
        artwork.save!
        get '/api/v1/artworks', params: {}, headers: { Authorization: "Bearer #{token.token}" }
        expect(response).to be_successful
        expect(JSON.parse(response.body).first).to eq(JSON.parse(artwork.to_json))
      end
    end
  end

  describe 'GET #show' do
    context 'when unauthorized' do
      it 'fails with HTTP 401' do
        get '/api/v1/artworks/1'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized' do
      let(:application) { FactoryBot.create(:application) }
      let(:user)        { FactoryBot.create(:user) }
      let(:artwork) { FactoryBot.create(:artwork, user: user) }
      let(:token) { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }

      it 'succeeds' do
        artwork.save!
        get "/api/v1/artworks/#{artwork.id}", params: {}, headers: { Authorization: "Bearer #{token.token}" }
        expect(response).to be_successful
        expect(JSON.parse(response.body)).to eq(JSON.parse(artwork.to_json))
      end
    end
  end
end
