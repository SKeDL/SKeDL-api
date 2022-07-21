Rails.application.routes.draw do
  post "account", to: "account#create" # Sign Up
  put "account", to: "account#update" # update account info
  delete "account", to: "account#destroy" # delete account

  resources :users

  resources :sessions, except: [:update]
  put "sessions", to: "sessions#update"
end
