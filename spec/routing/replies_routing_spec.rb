# frozen_string_literal: true

RSpec.describe RepliesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/discussions/1/replies').to route_to('replies#index', discussion_id: '1')
    end

    it 'routes to #new' do
      expect(get: '/discussions/1/replies/new').to route_to('replies#new', discussion_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/discussions/1/replies/1').to route_to('replies#show', id: '1', discussion_id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/discussions/1/replies/1/edit').to route_to('replies#edit', id: '1', discussion_id: '1')
    end

    it 'routes to #create' do
      expect(post: '/discussions/1/replies').to route_to('replies#create', discussion_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/discussions/1/replies/1').to route_to('replies#update', id: '1', discussion_id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/discussions/1/replies/1').to route_to('replies#update', id: '1', discussion_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/discussions/1/replies/1').to route_to('replies#destroy', id: '1', discussion_id: '1')
    end
  end
end
