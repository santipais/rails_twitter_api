# frozen_string_literal: true

module Api
  module V1
    module Users
      class FollowsController < ApiController
        def create
          current_user.follows.create!(followed: user)
          render status: :no_content
        end

        def destroy
          current_user.follows.find_by!(followed: user).destroy!
          render status: :no_content
        end

        private

        def user
          User.find_by!(username: params[:user_id])
        end
      end
    end
  end
end
