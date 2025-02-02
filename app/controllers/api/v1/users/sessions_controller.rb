# frozen_string_literal: true

module Api
  module V1
    module Users
      class SessionsController < Devise::SessionsController
        include FakeSession

        skip_before_action :verify_authenticity_token, with: :null_session
        respond_to :json

        def respond_with(resource, _opts = {})
          render json: UserSerializer.render(resource, view: :simple), status: :ok
        end

        def respond_to_on_destroy
          if current_user
            render json: UserSerializer.render(current_user, view: :simple), status: :ok
          else
            render json: { message: 'No active session' }, status: :not_found
          end
        end
      end
    end
  end
end
