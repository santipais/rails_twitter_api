# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApiController
      skip_before_action :authenticate_user!, only: %i[show]

      def show
        user = User.find(params[:id])
        render json: UserSerializer.render(user, view: :extended)
      end

      def update
        user = User.find(params[:id])

        return render json: { error: 'Unauthorized.' }, status: :unauthorized unless current_user == user

        if user.update(update_params)
          render(json: UserSerializer.render(user, view: :extended),
                 status: :ok)
        else
          render(json: user.errors, status: :unprocessable_entity)
        end
      end

      private

      def update_params
        params.require(:user).permit(:birthdate, :website, :bio, :first_name, :last_name)
      end
    end
  end
end
