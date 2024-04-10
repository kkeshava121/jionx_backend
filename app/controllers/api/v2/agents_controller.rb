class Api::V2::AgentsController < Api::V2::MobileBaseController
    skip_before_action :verify_authenticity_token
    before_action :authenticate_modem!, only: [:insert_multiple_messages]

    # POST /api/v2/agents/veriy_agent_by_pincode
    def verify_agent_by_pincode
        result = User.veify_pincode(params)
        render json: result
    end

    # POST /api/v2/agents/insert_or_update_modem
    def insert_or_update_modem
        if params[:id].present?
            modem = Modem.find_by(id: params[:id])
            if modem.present?
                updated_modem = Modem.update_modem_info(params, modem)
                render_success(updated_modem, status: 200)
            else
                render json: { data: nil, status: 403, message: "Modem not found"}
            end
        else
            render json: { data: nil, status: 403, message: "Modem not found OR modem id missing"}
            # modem = Modem.find_by(phone_number: params[:phone_number], device_id: params[:device_id])
            # if !modem.present?
            #     access_key = Modem.generate_access_key
            #     modem = Modem.new(modem_params)
            #     if modem.save
            #         # Activate and deactivate according to previous device modem
            #         device_id = modem_params[:device_id]
            #         active_modems = Modem.where(device_id: device_id, suspended: false)
            #         if active_modems.present?
            #             Modem.action_bulk(modem, false)
            #             modem.update(access_key: access_key, suspended: false)
            #         else
            #             modem.update(access_key: access_key)
            #         end
            #         render_success(modem, status: 200)
            #     else
            #         render json: modem.errors, status: :unprocessable_entity
            #     end
            # else
            #     render_success(modem, status: 200)
            # end
        end
    end

    # POST /api/v2/agents/insert_multiple_messages
    def insert_multiple_messages
        Message.create_or_update(params)
        render json: { data: true, status: 200, message: "success" }
    end

    # POST /api/v2/agents/verify_modem
    def verify_modem
        agent_pin = params[:agent_pin]
        phone_number = params[:phone_number]
        agent = User.find_by(pin_code: agent_pin)
        if agent.present?
            modem = Modem.find_by(user_id: agent.id, phone_number: phone_number)
            if modem.present?
                data = {
                    id: modem.id,
                    access_key: modem.access_key
                }
                render json: { data: data, status: 200, message: "Success"}
            else
                render json: { data: nil, status: 403, message: "Modem is not registered" }
            end
        else
            render json: { data: nil, status: 403, message: "Invalid pin" }
        end
    end


    private
    def modem_params
        params.permit(:sim_id, :sim_type, :operator, :phone_number, :device_id, :token, :device_info, :user_id, :is_active, :pincode)
    end

    def authenticate_modem!
        access_key = request.headers['Access-Key']
        if access_key.present?
            modem = Modem.find_by(access_key: access_key)
            if modem.present? and modem.suspended
                render json: { error: 'Suspended modem'}, status: :unauthorized
            elsif modem.present? and !modem.suspended
            else
                render json: { error: 'Invalid modem'}, status: :unauthorized
            end
        else
            render json: { error: 'Access key missing'}, status: :unauthorized
        end
    end
end
