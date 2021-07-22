Rails.application.routes.draw do
  resources :uploads
  get "about", to: "pages#about"
  get "contact", to: "pages#contact"
  get "welcome", to: "pages#welcome"

  root to: "pages#home"
end
