# frozen_string_literal: true

RSpec.describe '/artworks', type: :request do
  let(:user) { create(:user) }

  let(:valid_attributes) do
    { 'title' => 'Test Artwork',
      'user_id' => user.id,
      'metadata' => '{}',
      'status' => 'draft',
      'body' => '<p> test artwork body </p>',
      'description' => 'Test artwork description' }
  end

  let(:invalid_attributes) do
    { 'title' => nil,
      'user_id' => user.id,
      'metadata' => '{}',
      'status' => 'draft',
      'body' => '<p> test artwork body </p>',
      'description' => 'Test artwork description' }
  end

  before :each do
    login_as user
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Artwork.create! valid_attributes
      get artworks_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      artwork = Artwork.create! valid_attributes
      get artwork_url(id: artwork.id)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_artwork_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      artwork = Artwork.create! valid_attributes
      get edit_artwork_url(id: artwork.id)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Artwork' do
        expect do
          post artworks_url, params: { artwork: valid_attributes }
        end.to change(Artwork, :count).by(1)
      end

      it 'redirects to the created artwork' do
        post artworks_url, params: { artwork: valid_attributes }
        expect(response).to redirect_to(artwork_url(Artwork.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Artwork' do
        expect do
          post artworks_url, params: { artwork: invalid_attributes }
        end.to change(Artwork, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template with 422 response (turbo))" do
        post artworks_url, params: { artwork: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { 'title' => 'Updated Test Artwork',
          'status' => 'active' }
      end

      it 'updates the requested artwork' do
        artwork = Artwork.create! valid_attributes
        patch artwork_url(id: artwork.id), params: { artwork: new_attributes }
        artwork.reload
        expect(artwork.attributes).to include({ 'title' => 'Updated Test Artwork' })
      end

      it 'redirects to the artwork' do
        artwork = Artwork.create! valid_attributes
        patch artwork_url(id: artwork.id), params: { artwork: new_attributes }
        artwork.reload
        expect(response).to redirect_to(artwork_url(id: artwork.friendly_id))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template with 422 response (turbo))" do
        artwork = Artwork.create! valid_attributes
        patch artwork_url(id: artwork.id), params: { artwork: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested artwork' do
      artwork = Artwork.create! valid_attributes
      expect do
        delete artwork_url(id: artwork.id)
      end.to change(Artwork, :count).by(-1)
    end

    it 'redirects to the artworks list' do
      artwork = Artwork.create! valid_attributes
      delete artwork_url(id: artwork.id)
      expect(response).to redirect_to(artworks_url)
    end
  end
end
