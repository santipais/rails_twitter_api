# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  identifier :id

  fields :email, :username, :first_name, :last_name, :created_at
  field :birthdate, datetime_format: '%d/%m/%Y'

  view :show do
    excludes :id, :created_at, :first_name, :last_name
    field :bio, exclude_if_nil: true
    field :website, exclude_if_nil: true
    field :created_at, name: :date_joined, datetime_format: '%d/%m/%Y'
    field :name do |user| # rubocop:disable Style/SymbolProc
      user.full_name
    end
  end
end
