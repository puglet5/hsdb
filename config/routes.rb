# frozen_string_literal: true

Rails.application.routes.draw do
  get 'users/show'
  resources :categories
  resources :users
  resources :discussions do
    resources :replies
  end
  devise_for :users, path: '', path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  resources :uploads
  get 'about', to: 'pages#about'
  get 'contact', to: 'pages#contact'
  get 'welcome', to: 'pages#welcome'

  namespace :admin do 
    resources :users, only: %i[index]
  end
  
  root to: 'pages#home'
end
