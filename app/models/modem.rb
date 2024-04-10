class Modem < ApplicationRecord
    belongs_to :user
    class << self
        # Activation and deactivation of Modem
        def modem_activation(options)
            result = {}
            modem_params = options[:modem]
            suspended = modem_params[:suspended]
            modem = Modem.find_by(id: modem_params[:id])
            if modem.present?
                update_params = {
                    suspended: suspended
                }
                if suspended
                    update_params[:access_key] = Modem.generate_access_key
                end
                # To activate and deactivate all modems associated with device id
                modem.update(update_params)
                if modem.device_id.present?
                    action_bulk(modem, suspended)
                else
                    modem.update(suspended: suspended)
                end
                result[:data] = suspended
                result[:status] = 200
                result[:message] = "Updated Successfully"
            else
                result[:data] = nil
                result[:status] = 403
                result[:message] = "Modem not exist"
            end
            result
        end

        # Suspend and activate all with same device id # 11-Jan-2024
        def action_bulk(modem, action)
            device_id = modem.device_id
            # Suspend and activate all with same device id # 11-Jan-2024
            modems = Modem.where(device_id: device_id)
            if modems.present?
                modems.update_all(suspended: action)
            end
        end

        def generate_access_key
            access_key = get_has_key
            while Modem.exists?(access_key: access_key)
                access_key = get_has_key
            end
            access_key
        end

        def get_has_key
            SecureRandom.hex(20)
        end

        def remove_leading_zero(str)
            str.sub(/\A0/, '')
        end

        def create_new_modem(current_user, options)
            result = {}
            valid = modem_number_validation(options[:phone_number])
            # check number is already exist or not
            if valid
                phone_number = options[:phone_number]
                phone_number = '0' + phone_number unless phone_number.start_with?('0')
                user_id = options[:user_id]
                suspended = options[:suspended]
                access_key = Modem.generate_access_key
                agent = User.find_by(id: user_id)
                modem = Modem.new(user_id: user_id, phone_number: phone_number, suspended: suspended, access_key: access_key, pincode: agent.pin_code, is_active: true)
                modem.save
                result[:data] = modem
                result[:message] = "Successfully Created"
                result[:status] = 200
            else
                number_exist_response(result)
            end
            result
        end

        # Validation false response
        def number_exist_response(result)
            result[:data] = nil
            result[:message] = "This phone number already added"
            result[:status] = 403
            result
        end

        # Custom validation on modem phone number
        def modem_number_validation(phone_number)
            if phone_number.start_with?('0')
                phone_number = phone_number.sub(/^0/, '')
            end
            where_sql = %|modems.phone_number ILIKE '%#{phone_number}%'|
            modems = Modem.where(where_sql)
            modems.present? ? false : true
        end

        # To update modem info if modem already exists
        def update_modem_info(options, modem)
            modem_params = get_modem_params(options)
            modem_params[:access_key] = Modem.generate_access_key
            modem.update(modem_params)
            modem
        end

        # To get modems params
        def get_modem_params(options)
            options.permit(:sim_id, :sim_type, :operator, :device_id, :token, :device_info, :access_key)
        end
    end
end
