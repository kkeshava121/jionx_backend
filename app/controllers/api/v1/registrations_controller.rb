class Api::V1::RegistrationsController < Devise::RegistrationsController
    skip_before_action :verify_authenticity_token, if: -> { request.content_type == 'application/json' }
    respond_to :json
  
    def create
      role = Role.find_by(name: params[:role])
      build_resource(sign_up_params(params.merge(role_id: role.try(:id))))
      if resource.save
        # User.find(resource.id).update(role_id: role.try(:id))
        sign_up(resource_name, resource)
        render json: {data: resource, success: true}
      else
        render json: resource.errors, status: :unprocessable_entity
      end
    end

    private

    def sign_up_params(params)
        params.permit(:email, :password, :password_confirmation, :full_name, :user_name, :phone, :parent_id, :company_id, :country, :pin_code, :role_id)
    end
end
  