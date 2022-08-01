# frozen_string_literal: true

RSpec.describe SpectraController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/spectra').to route_to('spectra#index')
    end

    it 'routes to #new' do
      expect(get: '/spectra/new').to route_to('spectra#new')
    end

    it 'routes to #show' do
      expect(get: '/spectra/1').to route_to('spectra#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/spectra/1/edit').to route_to('spectra#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/spectra').to route_to('spectra#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/spectra/1').to route_to('spectra#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/spectra/1').to route_to('spectra#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/spectra/1').to route_to('spectra#destroy', id: '1')
    end
  end
end
