# frozen_string_literal: true

class TweetSerializer < ApplicationSerializer
  identifier :id

  field :content

  view :simple do
    field :created_at, name: :posted_ago do |tweet|
      time_ago_in_words(tweet.created_at)
    end
  end

  view :extended do
    field :created_at, name: :posted_ago do |tweet|
      time_ago_in_words(tweet.created_at)
    end
    association :user, blueprint: UserSerializer
  end
end
