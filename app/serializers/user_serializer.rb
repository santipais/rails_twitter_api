# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  identifier :id

  fields :email, :username, :first_name, :last_name, :birthdate, :created_at
end
