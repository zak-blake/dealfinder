Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => :registrations }
  get '/users/:id', to: 'users#show', as: 'user'
  get '/users', to: 'users#index', as: 'users'
  patch '/users/:id', to: 'users#update', as: 'update_user'

  resources :events

  get '/events_today', to: 'events#api_events_today'

  root 'events#index'
end
