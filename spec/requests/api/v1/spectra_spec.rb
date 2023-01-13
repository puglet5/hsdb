# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe Api::V1::SpectraController do
  before(:each) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  let(:application) { FactoryBot.create(:application) }
  let(:user)        { FactoryBot.create(:user) }
  let(:sample)      { FactoryBot.create(:sample, user: user) }
  let(:spectrum)    { FactoryBot.create(:spectrum, sample: sample) }
  let(:token)       { FactoryBot.create(:access_token, application: application, resource_owner_id: user.id) }

  before(:each) do
    @serializer = SpectrumSerializer.new(spectrum)
    @serialization = ActiveModelSerializers::Adapter.create(@serializer)
  end

  describe 'GET #index' do
    context 'when unauthorized' do
      it 'fails with HTTP 401' do
        get '/api/v1/spectra'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized' do
      subject { JSON.parse(@serialization.to_json) }

      it 'succeeds' do
        spectrum.save!
        get '/api/v1/spectra', params: {}, headers: { Authorization: "Bearer #{token.token}" }
        expect(response).to be_successful
        expect(subject['spectrum']).to eq(JSON.parse(response.body)['spectra'].first)
      end
    end
  end

  describe 'GET #show' do
    context 'when unauthorized' do
      it 'fails with HTTP 401' do
        get '/api/v1/spectra/1'
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authorized' do
      subject { JSON.parse(@serialization.to_json) }

      it 'succeeds' do
        get "/api/v1/spectra/#{spectrum.id}", params: {}, headers: { Authorization: "Bearer #{token.token}" }
        expect(response).to be_successful
        expect(subject).to eq(JSON.parse(response.body))
      end
    end
  end
end
