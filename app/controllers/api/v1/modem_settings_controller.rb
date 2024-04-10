class Api::V1::ModemSettingsController < Api::V1::BaseController

    def index
    end

    def insert_or_update_modem_setting
        modem_setting = ModemSetting.find_or_initialize_by(id: params[:id])
        modem_setting.assign_attributes(modem_setting_params)
        if modem_setting.save
            render_success(modem_setting, status: 200)
        else
            render json: modem_setting.errors, status: :unprocessable_entity
        end
    end

    def get_all_modem_settings
        modem_settings = ModemSetting.all.order(updated_at: :desc)
        modem_settings = JSON.parse(modem_settings.to_json)
        modem_settings.each do |ms|
            bank_id = ms["bank_id"]
            bank = Bank.find_by(id: bank_id)
            ms["bank_name"] = bank.try(:bank_name)
        end
        render_success(modem_settings, status: 200)
    end

    def delete_modem
        begin
            modem_setting = ModemSetting.find_by(id: params[:id])
            if modem_setting.present?
                modem_setting.destroy
                render_success("Deleted Successfully", status: 200)
            else
                render_error("Recod not found")
            end
        rescue Exception => e
            render_error("Error ==> #{e.message}")
        end
    end

    private
    def modem_setting_params
        params.permit(:balance_check_USSD, :cash_in_USSD, :bank_id)
    end
end
