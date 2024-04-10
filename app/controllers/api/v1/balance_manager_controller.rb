class Api::V1::BalanceManagerController < Api::V1::BaseController
    def index
    end

    def get_balance_by_filter
        res = BalanceManager.get_list(params, current_user)
        render json: res
    end

    def update_status
        bm = BalanceManager.find_by(id: params[:id])
        if bm.present?
            BalanceManager.where(transaction_id: bm.transaction_id).update_all(status: params[:balance_status])
            render json: { data: bm, success: true, message: "Status updated successfully" }
        else
            render json: { success: false, message: "Record Not Found" }
        end
    end

    def update_multiple_status
        bm = BalanceManager.where(id: params[:ids])
        if bm.present?
            bm.update_all(status: params[:balance_status])
            render json: { data: bm, success: true, message: "Status updated successfully" }
        else
            render json: { success: false, message: "Record Not Found" }
        end
    end

    def get_status_count
        # Role Based check
        current_role = current_user.role.try(:name)
        case current_role
        when 'Agent'
            balance_status_count = current_user.balance_managers.group(:status).count
        when 'Merchant'
            agents = User.where(merchant_id: current_user.id)
            agent_ids = agents.pluck(:id)
            balance_status_count = BalanceManager.where(user_id: agent_ids).group(:status).count
        else
            balance_status_count = BalanceManager.group(:status).count
        end
        render json: { data: balance_status_count, status: true, message: "Success" }
    end

    def todays_data
        result = []
        current_role = current_user.role.try(:name)
        if current_role === "Agent"
            today_start = Time.zone.now.beginning_of_day
            today_end = Time.zone.now.end_of_day
            data = BalanceManager.where(created_at: today_start..today_end, user_id: current_user.id)
        end
        render json: { data: data, status: true, message: "Success" }
    end

    #GET /api/v1/balance_manager/get_status_count
    # To get the daily bl status for agent app
    def daily_status_count
        current_role = current_user.role.try(:name)
        balance_status_count = {"success"=>0, "pending"=>0, "rejected"=>0, "danger"=>0, "approved"=>0}
        if current_role === "Agent"
            today = Date.today
            records = current_user.balance_managers.where(created_at: today.beginning_of_day..today.end_of_day).group(:status).count
            balance_status_count = records.empty? ? balance_status_count : records
        end
        render json: { data: balance_status_count, status: 200, message: "Success" }
    end

    private

    def balance_params
        params.permit(:sender, :type, :customer_account_no, :agent_account_no, :old_balance, :amount, :commision, :last_balance, :transaction_id, :message, :user_id, :status, :date)
    end
end
