class Api::V1::MessagesController < Api::V1::BaseController
    def index
    end

    def get_messages_by_filter
        response = BalanceManager.sms_by_filter(params, current_user)
        render json: response
    end

    def insert_multiple_messages
        Message.create_or_update(params)
        render json: { data: true, status: 200, message: "success" }
    end

    def todays_data
        result = []
        current_role = current_user.role.try(:name)
        if current_role === "Agent"
            today_start = Time.zone.now.beginning_of_day
            today_end = Time.zone.now.end_of_day
            data = Message.where(created_at: today_start..today_end, user_id: current_user.id)
        end
        render json: { data: data, status: true, message: "Success" }
    end
end
