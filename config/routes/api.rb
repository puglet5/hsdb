# frozen_string_literal: true

namespace 'api' do
  namespace 'v1' do
    scope :users, module: :users do
      post '/', to: 'registrations#create', as: :user_registration
    end
    resources :artworks
    resources :samples
    resources :spectra
  end
end
scope 'api' do
  use_doorkeeper do
    skip_controllers :authorizations, :authorized_applications
  end
end
