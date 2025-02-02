# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: 'api/v1/users', defaults: { format: :json },
                     controllers: { sessions: 'api/v1/users/sessions',
                                    registrations: 'api/v1/users/registrations',
                                    confirmations: 'api/v1/users/confirmations',
                                    passwords: 'api/v1/users/passwords' }

  namespace :api do
    namespace :v1 do
      resources :users, only: %i[show update] do
        resources :tweets, only: %i[index], controller: 'users/tweets'
      end
      resources :tweets, only: %i[create show] do
        resource :likes, only: %i[create destroy], controller: 'tweets/likes'
      end
    end
  end
end
