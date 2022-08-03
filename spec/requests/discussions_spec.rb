# frozen_string_literal: true

RSpec.describe '/discussions', type: :request do
  let(:user) { create(:user) }
  let(:category) { create(:category) }

  let(:valid_attributes) do
    { 'title' => 'Test Discussion',
      'user_id' => user.id,
      'category_id' => category.id,
      'content' => 'test html content' }
  end

  let(:invalid_attributes) do
    { 'title' => nil,
      'user_id' => user.id,
      'category_id' => category.id,
      'content' => 'test html content' }
  end

  before :each do
    login_as user
    # allow(controller).to receive(:current_user) { user }
    # sign_in :user, user
  end

  describe 'GET /index' do
    it 'renders a successful response' do
      Discussion.create! valid_attributes
      get discussions_url
      expect(response).to be_successful
    end
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      discussion = Discussion.create! valid_attributes
      get discussion_url(id: discussion.id)
      expect(response).to be_successful
    end
  end

  describe 'GET /new' do
    it 'renders a successful response' do
      get new_discussion_url
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      discussion = Discussion.create! valid_attributes
      get edit_discussion_url(id: discussion.id)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Discussion' do
        expect do
          post discussions_url, params: { discussion: valid_attributes }
        end.to change(Discussion, :count).by(1)
      end

      it 'redirects to the created discussion' do
        post discussions_url, params: { discussion: valid_attributes }
        expect(response).to redirect_to(discussion_url(Discussion.last))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Discussion' do
        expect do
          post discussions_url, params: { discussion: invalid_attributes }
        end.to change(Discussion, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template with 422 response (turbo))" do
        post discussions_url, params: { discussion: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { 'title' => 'Updated Test Discussion' }
      end

      it 'updates the requested discussion' do
        discussion = Discussion.create! valid_attributes
        patch discussion_url(id: discussion.id), params: { discussion: new_attributes }
        discussion.reload
        expect(discussion.attributes).to include({ 'title' => 'Updated Test Discussion' })
      end

      it 'redirects to the discussion' do
        discussion = Discussion.create! valid_attributes
        patch discussion_url(id: discussion.id), params: { discussion: new_attributes }
        discussion.reload
        expect(response).to redirect_to(discussion_url(id: discussion.friendly_id))
      end
    end

    context 'with invalid parameters' do
      it "renders a successful response (i.e. to display the 'edit' template with 422 response (turbo))" do
        discussion = Discussion.create! valid_attributes
        patch discussion_url(id: discussion.id), params: { discussion: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested discussion' do
      discussion = Discussion.create! valid_attributes
      expect do
        delete discussion_url(id: discussion.id)
      end.to change(Discussion, :count).by(-1)
    end

    it 'redirects to the discussions list' do
      discussion = Discussion.create! valid_attributes
      delete discussion_url(id: discussion.id)
      expect(response).to redirect_to(discussions_url)
    end
  end
end
