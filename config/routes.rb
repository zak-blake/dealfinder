Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => :registrations }
  get '/users/:id', to: 'users#show', as: 'user_show'

  resources :events

  root 'events#index'

  # Connect with app
  get 'events_today', to: 'events#day'
end
