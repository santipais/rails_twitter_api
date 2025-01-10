# frozen_string_literal: true

module Api
  module V1
    class ApiController < Api::ApplicationController
      def me
        render json: UserSerializer.render(current_user, view: :me)
      end
    end
  end
end
