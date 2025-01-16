# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :tweet

  validates :user_id, uniqueness: { scope: :tweet_id, message: :already_liked }
  validate :validate_user_cannot_like_own_tweet

  private

  def validate_user_cannot_like_own_tweet
    return if tweet.blank? || user.blank?

    errors.add(:base, :cannot_like_own_tweet) if user_id == tweet.user_id
  end
end
