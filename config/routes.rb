Rails.application.routes.draw do
  resources :sessions, only: [:new, :create, :destroy]
  resources :departments, except: :show
  resources :users

  root 'users#directory'

  match '/login', to: 'sessions#new', via: 'get'
  match '/logout', to: 'sessions#destroy', via: 'delete'
  match '/directory', to: 'users#directory', via: 'get'
  match '/directory', to: 'users#directory', via: 'post'
end
