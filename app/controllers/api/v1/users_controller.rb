# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      skip_before_action :authenticate_user!

      def show
        user = User.find(params[:id])
        render json: UserSerializer.render(user, view: :show)
      end
    end
  end
end
