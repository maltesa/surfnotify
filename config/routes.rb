require 'resque/server'

Rails.application.routes.draw do
  resources :notifications
  root to: 'pages#index'
  get 'provider/msw/find/:query' => 'provider#msw_search_spots', as: :msw_autocomplete
  get 'settings' => 'settings#edit', as: :settings
  put 'settings' => 'settings#update'
  patch 'settings' => 'settings#update'

  mount Resque::Server.new, :at => '/resque'

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
end
