Rails.application.routes.draw do
  resources :categories
  resources :discussions do
    resources :replies
  end
  devise_for :users, path: "", path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" }
  resources :uploads
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"
  get "welcome", to: "pages#welcome"

  root to: "pages#home"
end
