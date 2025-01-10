# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, path: 'api/v1/users', defaults: { format: :json },
                     controllers: { sessions: 'api/v1/users/sessions', registrations: 'api/v1/users/registrations' }

  namespace :api do
    namespace :v1 do
      get 'me' => 'api#me'
    end
  end
end
