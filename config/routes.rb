# frozen_string_literal: true

Rails.application.routes.draw do
  scope '(:locale)', locale: /#{I18n.available_locales.join('|')}/ do
    namespace :api do
      resources :categories, only: :update
    end

    resources :users
    get 'users/show'
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
      resources :users, only: %i[index create edit update destroy]
    end

    root to: 'pages#home'
  end
end
