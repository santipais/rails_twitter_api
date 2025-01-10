# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  identifier :id

  fields :email, :created_at

  view :me do
    excludes :id, :created_at
  end
end
