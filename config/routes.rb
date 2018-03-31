require 'resque/server'

Rails.application.routes.draw do
  root to: 'pages#index'
  get 'pages/terms', as: :terms_page

  resources :notifications, except: [:show]
  get 'notifications/silence/:id' => 'notifications#toggle_silent', as: :silence_notification
  get 'provider/msw/find/:query' => 'provider#msw_search_spots', as: :msw_autocomplete

  get 'settings' => 'settings#edit', as: :settings
  put 'settings' => 'settings#update'
  patch 'settings' => 'settings#update'

  devise_for :users, controllers: { sessions: 'users/sessions' }

  ## Resque Webinterface
  resque_web_constraint = lambda do |request|
    current_user = request.env['warden'].user
    current_user.present? && current_user.respond_to?(:is_admin?) && current_user.is_admin?
  end

  constraints resque_web_constraint do
    mount Resque::Server.new, :at => '/resque'
  end
end
