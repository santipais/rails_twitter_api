# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      skip_before_action :authenticate_user!, only: %i[show]
      before_action :correct_user?, only: :update

      def show
        render json: UserSerializer.render(user, view: :extended)
      end

      def update
        user.update!(update_params)
        render(json: UserSerializer.render(user, view: :extended), status: :ok)
      end

      private

      def update_params
        params.require(:user).permit(:username, :birthdate, :website, :bio, :first_name, :last_name)
      end

      def user
        @user ||= User.find(params[:id])
      end

      def correct_user?
        render json: { error: 'Unauthorized.' }, status: :unauthorized unless current_user.id == user.id
      end
    end
  end
end
