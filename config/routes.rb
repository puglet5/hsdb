# frozen_string_literal: true

# == Route Map
#

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(user) { user.has_role?('admin') } do
    mount Rswag::Ui::Engine => 'api-docs'
    mount Rswag::Api::Engine => 'api-docs'
    mount Sidekiq::Web => 'admin/sidekiq'
  end

  draw :api

  # scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
  resources :samples do
    resources :spectra do
      member do
        get :request_processing
      end
    end
    member do
      patch :favorite
    end
  end

  resources :users, only: %i[show] do
    member do
      patch :update_settings
    end
  end

  get 'artworks/resources/images', to: 'artworks#images'
  resources :categories
  resources :discussions do
    resources :replies
    member do
      patch :favorite
    end
  end
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }

  resources :artworks do
    member do
      patch :update_status
      patch :favorite
      get :images_grid
    end
  end

  namespace :admin do
    resources :users, only: %i[index edit update destroy]
  end

  root to: 'pages#home'
  # end
end
