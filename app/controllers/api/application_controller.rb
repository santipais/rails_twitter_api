# frozen_string_literal: true

module Api
  class ApplicationController < ActionController::API
    before_action :authenticate_user!

    rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid

    private

    def render_not_found(exception)
      Rails.logger.info { exception }
      render json: { error: I18n.t(:resource_not_found) }, status: :not_found
    end

    def render_record_invalid(exception)
      Rails.logger.info { exception }
      render json: { errors: exception.record.errors.as_json }, status: :bad_request
    end
  end
end
