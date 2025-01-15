# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  identifier :id

  fields :email, :username, :first_name, :last_name
  field :birthdate, datetime_format: '%d/%m/%Y'

  view :simple do
    field :created_at
  end

  view :extended do
    fields :bio, :website
    field :created_at, name: :date_joined, datetime_format: '%d/%m/%Y'
  end
end
