Rails.application.routes.draw do
  devise_for :users
  get '/users/:id', to: 'users#show', as: 'user_show'

  resources :events

  get '/test_info', to: 'users#test_info', as: 'test_info'

  root 'events#index'
end
