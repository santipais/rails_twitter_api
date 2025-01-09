# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: 'api/v1/users', defaults: { format: :json }

  # Defines the root path route ("/")
  # root "articles#index"
end
