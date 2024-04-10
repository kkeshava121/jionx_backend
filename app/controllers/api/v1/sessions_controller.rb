# app/controllers/api/v1/sessions_controller.rb
class Api::V1::SessionsController < Devise::SessionsController
    skip_before_action :verify_authenticity_token, if: -> { request.content_type == 'application/json' }
    respond_to :json
  
    def create
        resource = User.find_for_database_authentication(email: params[:email])
        if resource&.valid_password?(params[:password])
          sign_in(resource)
          role = Role.find_by(id: resource.role_id)
          begin
            resource.login_logs.create(login_time: Time.now, ip_address: request.ip)
          rescue Exception => e
            puts "Error Login Log ==> #{e.message}"
          end
          render json: { data: { token: generate_access_token(resource), userDetail: resource.as_json(except: :pin_code), userRoles: [role.try(:name)], permissions: role.try(:permissions) }, status: 200, message: "Success" }
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
    end

    def destroy
        sign_out(current_user) if user_signed_in?
        render json: { success: true, message: 'Logged out successfully.' }
    end

    private

    def generate_access_token(user)
        payload = { 
            user_id: user.id,
            exp: (3).hour.from_now.to_i
        }
        token = JWT.encode(payload, Rails.application.credentials.dig(:secret_key_base))
        token
    end

end