# frozen_string_literal: true

RSpec.describe '/replies', type: :request do
  let(:user) { create(:user) }
  let(:discussion) { create(:discussion) }

  let(:valid_attributes) do
    { 'reply' => 'Test Reply',
      'user_id' => user.id,
      'discussion_id' => discussion.id }
  end

  let(:invalid_attributes) do
    { 'reply' => nil,
      'user_id' => user.id,
      'discussion_id' => discussion.id }
  end

  before :each do
    login_as user
  end

  describe 'GET /show' do
    it 'renders a successful response' do
      Reply.create! valid_attributes
      get discussion_url(id: discussion.friendly_id)
      expect(response).to be_successful
    end
  end

  describe 'GET /edit' do
    it 'renders a successful response' do
      reply = Reply.create! valid_attributes
      get edit_discussion_reply_url(id: reply.id, discussion_id: discussion.id)
      expect(response).to be_successful
    end
  end

  describe 'POST /create' do
    context 'with valid parameters' do
      it 'creates a new Reply' do
        expect do
          post discussion_replies_url(discussion_id: discussion.id), params: { reply: valid_attributes }
        end.to change(Reply, :count).by(1)
      end

      it 'redirects to the discussion' do
        post discussion_replies_url(discussion_id: discussion.id), params: { reply: valid_attributes }
        expect(response).to redirect_to(discussion_url(id: discussion.friendly_id))
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Reply' do
        expect do
          post discussion_replies_url(discussion_id: discussion.id), params: { reply: invalid_attributes }
        end.to change(Reply, :count).by(0)
      end

      it 'renders a successful response (i.e. to display the discussion page with 422 response (turbo))' do
        post discussion_replies_url(discussion_id: discussion.id), params: { reply: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'PATCH /update' do
    context 'with valid parameters' do
      let(:new_attributes) do
        { 'reply' => 'Updated Test Reply' }
      end

      it 'updates the requested reply' do
        reply = Reply.create! valid_attributes
        patch discussion_reply_url(id: reply.id, discussion_id: discussion.id), params: { reply: new_attributes }
        reply.reload
        expect(reply.attributes).to include({ 'reply' => 'Updated Test Reply' })
      end

      it 'redirects to the discussion page' do
        reply = Reply.create! valid_attributes
        patch discussion_reply_url(id: reply.id, discussion_id: discussion.id), params: { reply: new_attributes }
        reply.reload
        expect(response).to redirect_to(discussion_url(id: discussion.friendly_id))
      end
    end

    context 'with invalid parameters' do
      it 'renders a successful response (i.e. to display the discussion page template with 422 response (turbo))' do
        reply = Reply.create! valid_attributes
        patch discussion_reply_url(id: reply.id, discussion_id: discussion.id), params: { reply: invalid_attributes }
        expect(response.status).to eq(422)
      end
    end
  end

  describe 'DELETE /destroy' do
    it 'destroys the requested reply' do
      reply = Reply.create! valid_attributes
      expect do
        delete discussion_reply_url(id: reply.id, discussion_id: discussion.id)
      end.to change(Reply, :count).by(-1)
    end

    it 'redirects to the discussion' do
      reply = Reply.create! valid_attributes
      delete discussion_reply_url(id: reply.id, discussion_id: discussion.id)
      expect(response).to redirect_to(discussion_url(id: discussion.friendly_id))
    end
  end
end
