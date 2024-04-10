class Api::V2::MobileBaseController < ApplicationController
    skip_before_action :verify_authenticity_token, if: -> { request.content_type == 'application/json' }
    before_action :authenticate_agent!
    protected

    def render_success(data = {}, status: :ok)
      render json: { success: true, data: data }, status: status
    end

    def render_error(message, status: :unprocessable_entity)
      render json: { success: false, error: message }, status: status
    end

    private

    def authenticate_agent!
      app_version = request.headers['App-Version']&.strip
      if app_version.present? and (app_version === '3.0.2' or app_version === '3.0.3')
        token = request.headers['Authorization']&.split&.last
        if MODEM_APP_API_CODE != token
          render json: { error: 'Invalid access token' }, status: :unauthorized
        end
      else
        render json: { error: 'Invalid app version' }, status: :unauthorized
      end
    end
end