Rails.application.routes.draw do
  resources :notifications
  root to: 'pages#index'
  get  'pages/landing', as: 'landing'

  get 'provider/msw/find/:query' => 'provider#msw_search_spots', as: :msw_autocomplete

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
end
