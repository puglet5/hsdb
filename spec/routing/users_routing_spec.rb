# frozen_string_literal: true

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/users/1').to route_to('users#show', id: '1')
    end

    it 'routes to #update_settings' do
      expect(get: '/users/1').to route_to('users#show', id: '1')
    end
  end
end
