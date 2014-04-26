Rails.application.routes.draw do
  resources :sessions, only: [:new, :create, :destroy]
  resources :departments, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :users

  root 'users#index'

  match '/login', to: 'sessions#new', via: 'get'
  match '/logout', to: 'sessions#destroy', via: 'delete'
end
