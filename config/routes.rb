# frozen_string_literal: true
Rails.application.routes.draw do
  namespace :api do
    post 'user_token' => 'user_token#create'
    resources :posts
    resources :users, only: :create
  end
end
