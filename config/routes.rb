# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(user) { user.has_role?('admin') } do
    mount Sidekiq::Web => '/sidekiq'
  end

  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    namespace :api do
      resources :categories, only: :update
    end

    resources :spectra do
      member do
        delete :purge_attachment
      end
    end

    resources :users, only: %i[show] do
      member do
        post :update_settings
      end
    end

    get 'uploads/resources/images', to: 'uploads#images'
    resources :categories
    resources :discussions do
      resources :replies
    end
    devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }

    resources :uploads do
      member do
        delete :purge_attachment
        patch :update_status
      end
    end

    get 'about', to: 'pages#about'

    namespace :admin do
      resources :users, only: %i[index edit update destroy]
    end

    root to: 'pages#home'
  end
end
