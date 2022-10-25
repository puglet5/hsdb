# frozen_string_literal: true

RSpec.describe '/samples', type: :request do
  let(:user) { create(:user) }

  let(:valid_attributes) do
    { 'title' => 'Test Sample',
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
      Sample.create! valid_attributes
      get samples_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      sample = Sample.create! valid_attributes
      get sample_url(id: sample.id)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_sample_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      sample = Sample.create! valid_attributes
      get edit_sample_url(id: sample.id)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Sample' do
        expect do
          post samples_url, params: { sample: valid_attributes }
        end.to change(Sample, :count).by(1)
      end

      it 'redirects to the created sample' do
        post samples_url, params: { sample: valid_attributes }
        expect(response).to redirect_to(sample_url(Sample.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Sample' do
        expect do
          post samples_url, params: { sample: invalid_attributes }
        end.to change(Sample, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template with 422 response (turbo))" do
        post samples_url, params: { sample: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { 'title' => 'Updated Test Sample',
          'processing_status' => 2 }
      end

      it 'updates the requested sample' do
        sample = Sample.create! valid_attributes
        patch sample_url(id: sample.id), params: { sample: new_attributes }
        sample.reload
        expect(sample.attributes).to include({ 'title' => 'Updated Test Sample' })
      end

      it 'redirects to the sample' do
        sample = Sample.create! valid_attributes
        patch sample_url(id: sample.id), params: { sample: new_attributes }
        sample.reload
        expect(response).to redirect_to(sample_url(id: sample.friendly_id))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template with 422 response (turbo))" do
        sample = Sample.create! valid_attributes
        patch sample_url(id: sample.id), params: { sample: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested sample' do
      sample = Sample.create! valid_attributes
      expect do
        delete sample_url(id: sample.id)
      end.to change(Sample, :count).by(-1)
    end

    it 'redirects to the samples list' do
      sample = Sample.create! valid_attributes
      delete sample_url(id: sample.id)
      expect(response).to redirect_to(samples_url)
    end
  end
end
