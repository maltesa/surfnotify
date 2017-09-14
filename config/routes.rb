Rails.application.routes.draw do
  resources :notifications
  root to: 'notifications#index'

  get 'provider/msw/find/:query' => 'provider#msw_search_spots', as: :msw_autocomplete

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
end
