# frozen_string_literal: true
require 'api_constraints'

Rails.application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    scope module: :v2, constraints: ApiConstraints.new(version: 2) do
      post 'user_token' => 'user_token#create'
      resources :posts do
        get 'page/:page', action: :index, on: :collection
      end
      resources :users, only: :create
    end

    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: :true) do
      post 'user_token' => 'user_token#create'
      resources :posts
      resources :users, only: :create
    end
  end
end
