# frozen_string_literal: true

RSpec.describe SamplesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/samples').to route_to('samples#index')
    end

    it 'routes to #new' do
      expect(get: '/samples/new').to route_to('samples#new')
    end

    it 'routes to #show' do
      expect(get: '/samples/1').to route_to('samples#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/samples/1/edit').to route_to('samples#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/samples').to route_to('samples#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/samples/1').to route_to('samples#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/samples/1').to route_to('samples#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/samples/1').to route_to('samples#destroy', id: '1')
    end
  end
end
