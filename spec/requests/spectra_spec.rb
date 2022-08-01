# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/spectra', type: :request do
  let(:user) { create(:user) }

  let(:valid_attributes) do
    { 'title' => 'Test Spectrum',
      'user_id' => user.id,
      'metadata' => '{}',
      'processing_status' => 1 }
  end

  let(:invalid_attributes) do
    { 'title' => nil,
      'user_id' => user.id,
      'metadata' => '{}',
      'processing_status' => 1 }
  end

  before :each do
    login_as user
    # allow(controller).to receive(:current_user) { user }
    # sign_in :user, user
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Spectrum.create! valid_attributes
      get spectra_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      spectrum = Spectrum.create! valid_attributes
      get spectrum_url(id: spectrum.id)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_spectrum_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      spectrum = Spectrum.create! valid_attributes
      get edit_spectrum_url(id: spectrum.id)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Spectrum' do
        expect do
          post spectra_url, params: { spectrum: valid_attributes }
        end.to change(Spectrum, :count).by(1)
      end

      it 'redirects to the created spectrum' do
        post spectra_url, params: { spectrum: valid_attributes }
        expect(response).to redirect_to(spectrum_url(Spectrum.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Spectrum' do
        expect do
          post spectra_url, params: { spectrum: invalid_attributes }
        end.to change(Spectrum, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template with 422 response (turbo))" do
        post spectra_url, params: { spectrum: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { 'title' => 'Updated Test Spectrum',
          'processing_status' => 2 }
      end

      it 'updates the requested spectrum' do
        spectrum = Spectrum.create! valid_attributes
        patch spectrum_url(id: spectrum.id), params: { spectrum: new_attributes }
        spectrum.reload
        expect(spectrum.attributes).to include({ 'title' => 'Updated Test Spectrum' })
      end

      it 'redirects to the spectrum' do
        spectrum = Spectrum.create! valid_attributes
        patch spectrum_url(id: spectrum.id), params: { spectrum: new_attributes }
        spectrum.reload
        expect(response).to redirect_to(spectrum_url(id: spectrum.friendly_id))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template with 422 response (turbo))" do
        spectrum = Spectrum.create! valid_attributes
        patch spectrum_url(id: spectrum.id), params: { spectrum: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested spectrum' do
      spectrum = Spectrum.create! valid_attributes
      expect do
        delete spectrum_url(id: spectrum.id)
      end.to change(Spectrum, :count).by(-1)
    end

    it 'redirects to the spectra list' do
      spectrum = Spectrum.create! valid_attributes
      delete spectrum_url(id: spectrum.id)
      expect(response).to redirect_to(spectra_url)
    end
  end
end
