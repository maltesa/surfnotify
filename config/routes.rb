require 'resque/server'

Rails.application.routes.draw do
  resources :notifications
  root to: 'pages#index'
  get 'provider/msw/find/:query' => 'provider#msw_search_spots', as: :msw_autocomplete

  get   'users/edit' => 'users#edit', as: :edit_user
  patch 'users/edit' => 'users#update', as: :user
  put   'users/edit' => 'users#update'

  mount Resque::Server.new, :at => '/resque'

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
end
