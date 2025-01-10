# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    before_action :authenticate_user!
  end
end
