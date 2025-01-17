# frozen_string_literal: true

class TweetSerializer < ApplicationSerializer
  identifier :id

  field :content
  association :user, blueprint: UserSerializer

  view :show do
    field :created_at, name: :posted_ago do |tweet|
      time_ago_in_words(tweet.created_at)
    end
  end
end
