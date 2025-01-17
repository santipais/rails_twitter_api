# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  identifier :id

  fields :username, :first_name, :last_name

  view :simple do
    fields :email, :bio, :website, :created_at
    field :birthdate, datetime_format: '%d/%m/%Y'
  end

  view :show do
    fields :email, :bio, :website, :tweets_count
    field :birthdate, datetime_format: '%d/%m/%Y'
    field :created_at, name: :date_joined, datetime_format: '%d/%m/%Y'
  end
end
