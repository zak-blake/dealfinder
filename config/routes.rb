Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => :registrations }
  get '/users/:id', to: 'users#show', as: 'user_show'

  resources :events

  get '/events_today', to: 'events#api_events_today'

  root 'events#index'
end
