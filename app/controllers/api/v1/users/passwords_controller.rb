# frozen_string_literal: true

module Api
  module V1
    module Users
      class PasswordsController < Devise::PasswordsController
        include FakeSession
        skip_before_action :verify_authenticity_token, with: :null_session
        respond_to :json
      end
    end
  end
end
