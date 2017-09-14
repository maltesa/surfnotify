Rails.application.routes.draw do
  resources :notifications
  root to: 'notifications#index'

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
end
