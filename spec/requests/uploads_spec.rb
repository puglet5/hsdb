# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/uploads', type: :request do
  let(:user) { create(:user) }

  let(:valid_attributes) do
    { 'title' => 'Test Upload',
      'user_id' => user.id,
      'metadata' => '{}',
      'status' => 'draft',
      'body' => '<p> test upload body </p>',
      'description' => 'Test upload description' }
  end

  let(:invalid_attributes) do
    { 'title' => nil,
      'user_id' => user.id,
      'metadata' => '{}',
      'status' => 'draft',
      'body' => '<p> test upload body </p>',
      'description' => 'Test upload description' }
  end

  before :each do
    login_as user
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Upload.create! valid_attributes
      get uploads_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      upload = Upload.create! valid_attributes
      get upload_url(id: upload.id)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_upload_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      upload = Upload.create! valid_attributes
      get edit_upload_url(id: upload.id)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Upload' do
        expect do
          post uploads_url, params: { upload: valid_attributes }
        end.to change(Upload, :count).by(1)
      end

      it 'redirects to the created upload' do
        post uploads_url, params: { upload: valid_attributes }
        expect(response).to redirect_to(upload_url(Upload.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Upload' do
        expect do
          post uploads_url, params: { upload: invalid_attributes }
        end.to change(Upload, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template with 422 response (turbo))" do
        post uploads_url, params: { upload: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { 'title' => 'Updated Test Upload',
          'status' => 'active' }
      end

      it 'updates the requested upload' do
        upload = Upload.create! valid_attributes
        patch upload_url(id: upload.id), params: { upload: new_attributes }
        upload.reload
        expect(upload.attributes).to include({ 'title' => 'Updated Test Upload' })
      end

      it 'redirects to the upload' do
        upload = Upload.create! valid_attributes
        patch upload_url(id: upload.id), params: { upload: new_attributes }
        upload.reload
        expect(response).to redirect_to(upload_url(id: upload.friendly_id))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template with 422 response (turbo))" do
        upload = Upload.create! valid_attributes
        patch upload_url(id: upload.id), params: { upload: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested upload' do
      upload = Upload.create! valid_attributes
      expect do
        delete upload_url(id: upload.id)
      end.to change(Upload, :count).by(-1)
    end

    it 'redirects to the uploads list' do
      upload = Upload.create! valid_attributes
      delete upload_url(id: upload.id)
      expect(response).to redirect_to(uploads_url)
    end
  end
end
