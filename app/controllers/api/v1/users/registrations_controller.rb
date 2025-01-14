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
            render json: UserSerializer.render(resource, view: :simple), status: :created
          else
            render json: resource.errors, status: :unprocessable_entity
          end
        end

        private

        def sign_up_params
          params.require(resource_name)
                .permit(:email, :username, :password, :birthdate, :website, :bio, :first_name, :last_name)
        end
      end
    end
  end
end
