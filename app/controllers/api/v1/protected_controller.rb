class Api::V1::ProtectedController < ApplicationController
    before_action :authenticate_user!
  
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