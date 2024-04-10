class Api::V1::BaseController < ApplicationController
    skip_before_action :verify_authenticity_token, if: -> { request.content_type == 'application/json' }
    before_action :authenticate_user!
    protected
  
    def render_success(data = {}, status: :ok)
      render json: { success: true, data: data }, status: status
    end
  
    def render_error(message, status: :unprocessable_entity)
      render json: { success: false, error: message }, status: status
    end

  
    private
  
    def authenticate_user!
      token = request.headers['Authorization']&.split&.last
      decoded_token = JWT.decode(token, Rails.application.credentials.dig(:secret_key_base))
      user_id = decoded_token.first['user_id']
      @current_user = User.find_by(id: user_id)
      unless @current_user
        render json: { error: 'Invalid access token' }, status: :unauthorized
      end
    rescue JWT::DecodeError
      render json: { error: 'Invalid access token' }, status: :unauthorized
    end
end
  