# frozen_string_literal: true

require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe '/spectra', type: :request do
  # This should return the minimal set of attributes required to create a valid
  # Spectrum. As you add validations to Spectrum, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    skip('Add a hash of attributes valid for your model')
  end

  let(:invalid_attributes) do
    skip('Add a hash of attributes invalid for your model')
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
      get spectrum_url(spectrum)
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
      get edit_spectrum_url(spectrum)
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

      it "renders a successful response (i.e. to display the 'new' template)" do
        post spectra_url, params: { spectrum: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        skip('Add a hash of attributes valid for your model')
      end

      it 'updates the requested spectrum' do
        spectrum = Spectrum.create! valid_attributes
        patch spectrum_url(spectrum), params: { spectrum: new_attributes }
        spectrum.reload
        skip('Add assertions for updated state')
      end

      it 'redirects to the spectrum' do
        spectrum = Spectrum.create! valid_attributes
        patch spectrum_url(spectrum), params: { spectrum: new_attributes }
        spectrum.reload
        expect(response).to redirect_to(spectrum_url(spectrum))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        spectrum = Spectrum.create! valid_attributes
        patch spectrum_url(spectrum), params: { spectrum: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested spectrum' do
      spectrum = Spectrum.create! valid_attributes
      expect do
        delete spectrum_url(spectrum)
      end.to change(Spectrum, :count).by(-1)
    end

    it 'redirects to the spectra list' do
      spectrum = Spectrum.create! valid_attributes
      delete spectrum_url(spectrum)
      expect(response).to redirect_to(spectra_url)
    end
  end
end