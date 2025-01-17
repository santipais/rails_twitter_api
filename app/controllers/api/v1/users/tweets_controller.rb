# frozen_string_literal: true

module Api
  module V1
    module Users
      class TweetsController < ApiController
        def index
          tweets = user.tweets.order(created_at: :desc)
          render json: TweetSerializer.render(tweets, view: :simple), status: :ok
        end

        private

        def user
          User.find_by!(username: params[:user_id])
        end
      end
    end
  end
end
