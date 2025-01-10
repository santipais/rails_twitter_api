# frozen_string_literal: true

require 'devise/jwt/test_helpers'

module AuthHelper
  def auth_header(user)
    Devise::JWT::TestHelpers.auth_headers({}, user)
  end
end
