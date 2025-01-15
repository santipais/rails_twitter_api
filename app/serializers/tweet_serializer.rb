# frozen_string_literal: true

class TweetSerializer < ApplicationSerializer
  identifier :id

  field :content
  association :user, blueprint: UserSerializer
end
