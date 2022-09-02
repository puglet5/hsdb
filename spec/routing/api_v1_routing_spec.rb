# frozen_string_literal: true

RSpec.describe Api::V1, type: :routing do
  describe 'routing' do
    context 'uploads' do
      it 'routes to #index' do
        expect(get: '/api/v1/uploads').to route_to('api/v1/uploads#index')
      end

      it 'routes to #show' do
        expect(get: '/api/v1/uploads/1').to route_to('api/v1/uploads#show', id: '1')
      end
    end

    context 'spectra' do
      it 'routes to #index' do
        expect(get: '/api/v1/spectra').to route_to('api/v1/spectra#index')
      end

      it 'routes to #show' do
        expect(get: '/api/v1/spectra/1').to route_to('api/v1/spectra#show', id: '1')
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
