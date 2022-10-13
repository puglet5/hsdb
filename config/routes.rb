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

  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    resources :spectra

    resources :users, only: %i[show] do
      member do
        patch :update_settings
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
        patch :update_status
        get :images_grid
      end
    end

    get 'about', to: 'pages#about'

    namespace :admin do
      resources :users, only: %i[index edit update destroy]
    end

    root to: 'pages#home'
  end
end
