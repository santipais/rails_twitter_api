# frozen_string_literal: true

module Api
  module V1
    module Tweets
      class LikesController < ApiController
        def create
          tweet.likes.create!(user: current_user)
          head :no_content
        end

        def destroy
          like = tweet.likes.find_by!(user: current_user)
          like.destroy!
          render status: :no_content
        end

        private

        def tweet
          Tweet.find(params[:tweet_id])
        end
      end
    end
  end
end
