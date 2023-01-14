# frozen_string_literal: true

RSpec.describe Api::V1, type: :routing do
  describe 'routing' do
    context 'artworks' do
      it 'routes to #index' do
        expect(get: '/api/v1/artworks').to route_to('api/v1/artworks#index')
      end

      it 'routes to #show' do
        expect(get: '/api/v1/artworks/1').to route_to('api/v1/artworks#show', id: '1')
      end
    end

    context 'samples' do
      it 'routes to #index' do
        expect(get: '/api/v1/samples').to route_to('api/v1/samples#index')
      end

      it 'routes to #show' do
        expect(get: '/api/v1/samples/1').to route_to('api/v1/samples#show', id: '1')
      end
    end

    context 'doorkeeper applications' do
      it 'routes to #index' do
        expect(get: '/api/oauth/applications').to route_to('doorkeeper/applications#index')
      end
      it 'routes to #show' do
        expect(get: '/api/oauth/applications/1').to route_to('doorkeeper/applications#show', id: '1')
      end
    end
  end
end
