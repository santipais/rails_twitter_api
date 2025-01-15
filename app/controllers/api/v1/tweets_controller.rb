# frozen_string_literal: true

module Api
  module V1
    class TweetsController < ApiController
      def create
        tweet = current_user.tweets.create!(tweet_params)
        render json: TweetSerializer.render(tweet), status: :created
      end

      private

      def tweet_params
        params.require(:tweet).permit(:content)
      end
    end
  end
end
