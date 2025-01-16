# frozen_string_literal: true

module Api
  module V1
    class TweetsController < ApiController
      def index
        user = User.find_by!(username: params[:user_id])
        tweets = user.tweets.order(created_at: :desc)
        render json: TweetSerializer.render(tweets, view: :simple), status: :ok
      end

      def show
        tweet = Tweet.find(params[:id])
        render json: TweetSerializer.render(tweet, view: :extended), status: :ok
      end

      def create
        tweet = current_user.tweets.create!(tweet_params)
        render json: TweetSerializer.render(tweet, view: :extended), status: :created
      end

      private

      def tweet_params
        params.require(:tweet).permit(:content)
      end
    end
  end
end
