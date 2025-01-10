# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < Devise::RegistrationsController
        include FakeSession

        skip_before_action :verify_authenticity_token, with: :null_session
        respond_to :json

        def respond_with(resource, _opts = {})
          if resource.persisted?
            render json: UserSerializer.render(resource), status: :created
          else
            render json: resource.errors, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
