Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => :registrations }
  get '/users/:id', to: 'users#show', as: 'user'
  get '/users', to: 'users#index', as: 'users'
  patch '/users/:id', to: 'users#update', as: 'update_user'

  resources :events

  get 'api/events_today', to: 'api#events_today'
  get 'api/users_index', to: 'api#users_index'

  root 'events#index'
end
