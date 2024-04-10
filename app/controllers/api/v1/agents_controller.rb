class Api::V1::AgentsController < Api::V1::MobileBaseController
    skip_before_action :verify_authenticity_token

    def verify_agent_by_pincode
        role = Role.find_by(name: "Agent")
        user = User.find_by(pin_code: params[:pincode], role_id: role.try(:id))
        if user.present?
            render json: {data: user, status: 200, message: "Success"}
        else
            render json: {data: false, status: 404, message: "Invalid pincode"}
        end
    end

    def insert_or_update_modem
         modem = Modem.find_by(phone_number: params[:phone_number], device_id: params[:device_id])
        if !modem.present?
            modem = Modem.new(modem_params)
            if modem.save
                render_success(modem, status: 200)
            else
                render json: modem.errors, status: :unprocessable_entity
            end
        else
            render_success("Modem already exist", status: 200)
        end
    end

    def insert_multiple_messages
        Message.create_or_update(params)
        render json: { data: true, status: 200, message: "success" }
    end



    private
    def modem_params
        params.permit(:sim_id, :sim_type, :operator, :phone_number, :device_id, :token, :device_info, :user_id, :is_active, :pincode)
    end

end
