# frozen_string_literal: true

module Api
  module V1
    module Tweets
      class LikesController < ApiController
        def create
          like = tweet.likes.create(user: current_user)
          if like.valid?
            render status: :no_content
          else
            render json: { errors: like.errors.full_messages }, status: :unprocessable_entity
          end
        end

        def destroy
          like = tweet.likes.find_by(user: current_user)
          if like
            like.destroy!
            render status: :no_content
          else
            render json: { errors: I18n.t(:not_liked) }, status: :unprocessable_entity
          end
        end

        private

        def tweet
          Tweet.find(params[:tweet_id])
        end
      end
    end
  end
end
