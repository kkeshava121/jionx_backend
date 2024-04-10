class Api::V1::UsersController < Api::V1::BaseController
    before_action :authenticate_user!, :except => [:verify_agent_by_pincode]
    include Devise::Controllers::Helpers
    include Devise::Controllers::SignInOut

    def destroy
        user = User.find(params[:id])
        if user.destroy
            render_success("Deleted Successfully", status: 200)
        else
            render_error("Error ==> #{user.errors}")
        end
    end

    def sign_out_user
        sign_out(current_user) if user_signed_in?
        render json: {data: [], status: 200, message: "Log out Successfully"}
    end

    def get_user_by_id
        user = User.find(params[:user_id])
        render json: {data: user, status: 200, message: "Success"}
    end

    #A method generate the 6 digit randome pincode.
    def generate_pincode
        new_pincode = rand(111111..999999)
        if new_pincode.present?
            render_success({data: new_pincode, status: :ok})
        else
            render_error("Pin Code not exist")
        end
    end

    def update_user
        user = User.find(params[:id])
        user.assign_attributes(user_params)
        if user.save
            render json: {data: user, status: 200, message: "Success"}
        else
            render json: {data: nil, status: 404, message: "Error user update"}
        end
    end

    def verify_user_by_pincode
        pincode = params[:pincode]
        if pincode.to_i == current_user.pin_code
            render json: {data: true, status: 200, message: "Success"}
        else
            render json: {data: false, status: 404, message: "Invalid pincode"}
        end
    end

    # GET /api/v1/users/get_users_by_parent_id_and_role?parent_id=:id&role=Agent
    def get_users_by_parent_id_and_role
        role_name = params[:role]
        parent_id = params[:parent_id].present? ? params[:parent_id] : nil
        role = Role.find_by(name: role_name)
        if role.present?
            users = User.where(parent_id: parent_id, role_id: role.id).order(created_at: :desc)
            render_success(users, status: 200)
        else
            render_success({data: [], status: 200})
        end
    end

    def verify_agent_by_pincode
        if !params[:modem_api_code].present? || params[:modem_api_code] != MODEM_APP_API_CODE
            render json: {data: false, status: 404, message: "API Key not authorized"}
            return
        end
        pincode = params[:pincode]
        user = User.find_by(pin_code: pincode)
        if user.present?
            render json: {data: user, status: 200, message: "Success"}
        else
            render json: {data: false, status: 404, message: "Invalid pincode"}
        end
    end

    def merchants_list
        role = Role.find_by(name: "Merchant")
        merchants = []
        begin
            merchants = role.users.select(:id, :email, :pin_code)
        rescue Exception => e
            puts "Role does't exist"
        end
        render json: {data: merchants, status: 200, message: "Success"}
    end

    def assign_or_remove_merchant
        user = User.find_by(id: params[:agent_id])
        if user.present?
            user.merchant_id = params[:type] === "assign" ? params[:merchant_id] : nil
            user.save
            render json: {data: nil, status: 200, message: "Success"}
        else
            render json: {data: false, status: 404, message: "Agent does't exist"}
        end
    end

    # Change a user password
    # POST /api/v1/users/change_password
    def change_password
        current_role = current_user.role.try(:name)
        if current_role != "Agent" || current_role != "Merchant"
            user = User.find_by(id: params[:id])
            if !user.present?
                render json: {data: nil, status: 404, message: "Not Found User"}
                return
            end
            if (params[:new_password].present? && params[:confirm_password].present?) && (params[:new_password] === params[:confirm_password])
                user.password = params[:new_password]
                if user.save
                  render json: {data: nil, status: 200, message: "Password updated successfully"}
                else
                  render json: {data: nil, status: 404, message: "Update password error: #{user.errors.join(', ')}"}
                end
            else
                render json: {data: nil, status: 404, message: "Password does't match"}
            end
        else
           render json: {data: false, status: 404, message: "Not allowed for this role -> #{current_role}"}
        end
    end

    def dashboard_data
        result = User.get_dashboard_data(current_user)
        render json: {data: result, status: 200}
    end

    private
    def user_params
        params.permit(:email, :full_name, :user_name, :phone, :parent_id, :company_id, :country, :pin_code)
    end
end
