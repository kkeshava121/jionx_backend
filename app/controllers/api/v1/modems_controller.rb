class Api::V1::ModemsController < Api::V1::BaseController
    # skip_before_action :verify_authenticity_token
    
    # To get list with filter and pagination
    def get_modems_by_filter
        current_role = current_user.role.try(:name)
        page_number = params[:page_number].to_i || 1
        page_size = params[:page_size].to_i || 10
        operator = params[:operator]
        device_id = params[:device_id]
        device_info = params[:device_info]
        phone_number = params[:phone_number]
        if current_role === "Agent"
            agent = current_user.email
        else
            agent = params[:agent]
        end
        is_active = params[:is_active].present? ? true : false
        where_sql_arr = []
        where_sql_arr << %|modems.device_id = '#{device_id}'| if device_id.present?
        where_sql_arr << %|modems.device_info LIKE '%#{device_info}%'| if device_info.present?
        where_sql_arr << %|modems.phone_number ILIKE '%#{phone_number}%'| if phone_number.present?
        where_sql_arr << %|users.email = '#{agent}'| if agent.present?
        where_sql_arr << %|modems.is_active = #{is_active}|
        where_sql = where_sql_arr.join(" AND ")
        filtered_record = Modem.joins(:user).where(where_sql).order(created_at: :desc)
        total_rows = filtered_record.count
        result = filtered_record.select('modems.id', 'modems.sim_type', 'modems.device_id', 'modems.device_info', 'modems.is_active', 'modems.phone_number', 'modems.suspended', 'modems.updated_at', 'users.email').offset((page_number - 1) * page_size).limit(page_size)
        result = result.each{|x| x.updated_at = "Not Setup" if !x.device_id.present? }
        render json: { data: result, total_rows: total_rows, status: 200, message: "success" }
    end

    def index
    end

    # To Create modem
    # POST /api/v1/modems
    def create
        result = Modem.create_new_modem(current_user, params)
        render json: result
    end

    # POST /api/v1/modems/modem_activation
    def modem_activation
        result = Modem.modem_activation(params)
        render json: result
    end

    #GET /api/v1/modems/:id/delete_modem
    def delete_modem
        result = {}
        current_role = current_user.role.try(:name)
        if current_role === "SuperAdmin"
            modem = Modem.find_by(id: params[:id])
            if modem.present?
                modem.destroy
                result[:status] = 200
                result[:message] = "Success"
            else
                result[:status] = 403
                result[:message] = "Modem Not Found"
            end
        else
            result[:status] = 403
            result[:message] = "Access Denied"
        end
        render json: result
    end

    # POST /api/v1/modems/modem_activation
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

    def get_all_modems
        current_role = current_user.role.name
        if current_role === "SuperAdmin"
            modems = Modem.all.order(created_at: :desc)
        elsif current_role === "Agent"
            modems = Modem.where(user_id: current_user.id).order(created_at: :desc)
        else
            modems = []
        end
        render json: {data: modems, status: 200, message: "Success"}
    end

    def delete_multi_modems
        begin
            modems = Modem.where(id: params[:ids])
            modems.delete_all
            render json: {status: 200, message: "Success"}
        rescue Exception => e
            render_error("Error ==> #{e.message}")
        end
    end

    def update_modem_status
        id = params[:id]
        modem_action = params[:modem_action]
        modem = Modem.find_by(id: id)
        modem.update(modem_action: modem_action)
        render_success("Updated status Successfully", status: 200)
    end

    private
    def modem_params
        params.permit(:sim_id, :sim_type, :operator, :phone_number, :device_id, :token, :device_info, :user_id, :is_active, :pincode)
    end
end
