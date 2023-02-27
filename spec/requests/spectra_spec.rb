# frozen_string_literal: true

RSpec.describe '/samples/spectra', type: :request do
  let(:user) { create(:user) }
  let(:sample) { create(:sample, user: user) }

  let(:valid_attributes) do
    { 'sample_id' => sample.id,
      'user_id' => user.id,
      'metadata' => '{}' }
  end

  let(:invalid_attributes) do
    { 'sample_id' => nil,
      'user_id' => nil,
      'metadata' => '{}' }
  end

  before :each do
    login_as user
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_sample_spectrum_url(sample_id: sample.id)
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      spectrum = Spectrum.create! valid_attributes
      get edit_sample_spectrum_url(id: spectrum.id, sample_id: sample.id)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Spectrum' do
        expect do
          post sample_spectra_url(sample_id: sample.id), params: { spectrum: valid_attributes }
        end.to change(Spectrum, :count).by(1)
      end

      it 'redirects to the sample' do
        post sample_spectra_url(sample_id: sample.id), params: { spectrum: valid_attributes }
        expect(response).to redirect_to(sample_url(id: sample.id))
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { 'category' => 'raman' }
      end

      it 'updates the requested sample' do
        spectrum = Spectrum.create! valid_attributes
        patch sample_spectrum_url(id: spectrum.id, sample_id: sample.id), params: { spectrum: new_attributes }
        spectrum.reload
        expect(spectrum.attributes).to include({ 'category' => 'raman' })
      end

      it 'redirects to the sample' do
        spectrum = Spectrum.create! valid_attributes
        patch sample_spectrum_url(id: spectrum.id, sample_id: sample.id), params: { spectrum: new_attributes }
        spectrum.reload
        expect(response).to redirect_to(sample_url(id: sample.id))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template with 422 response (turbo))" do
        spectrum = Spectrum.create! valid_attributes
        patch sample_spectrum_url(id: spectrum.id, sample_id: sample.id), params: { spectrum: nil }
        expect(response.status).to eq(400)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested sample' do
      spectrum = Spectrum.create! valid_attributes
      expect do
        delete sample_spectrum_url(id: spectrum.id, sample_id: sample.id)
      end.to change(Spectrum, :count).by(-1)
    end

    it 'redirects to the parent sample' do
      spectrum = Spectrum.create! valid_attributes
      delete sample_spectrum_url(id: spectrum.id, sample_id: sample.id)
      expect(response).to redirect_to(sample_url(sample))
    end
  end
end
