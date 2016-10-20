Rails.application.routes.draw do
  devise_for :users
  resources :events
  get '/owner_list/:id', to: 'events#owner_list', as: 'owner_list'

  root 'events#index'
end
