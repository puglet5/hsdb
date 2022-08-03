# frozen_string_literal: true

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #home' do
      expect(get: '/').to route_to('pages#home')
    end

    it 'routes to #about' do
      expect(get: '/about').to route_to('pages#about')
    end
  end
end
