class Message < ApplicationRecord
    belongs_to :user
    validates :message_id, uniqueness: { message: "Message already exist!" }
    def self.create_or_update(options = {})
        message_ids = []
        options[:messages].each do |raw_msg|
            message = {
                message_id: raw_msg[:message_id],
                text_message: raw_msg[:text_message].gsub("\n", " "),
                sender: raw_msg[:sender],
                receiver: raw_msg[:receiver],
                sim_slot: raw_msg[:sim_slot],
                sms_type: raw_msg[:sms_type],
                transaction_type: raw_msg[:transaction_type],
                android_id: raw_msg[:android_id],
                app_version: raw_msg[:app_version],
                sms_date: raw_msg[:sms_date],
                user_id: raw_msg[:user_id]
            }
            InsertMessagesJob.perform_async(message.as_json)
        end
        # self.proceed_for_balance_manager(message_ids)
    end

    def self.proceed_for_balance_manager(ids)
        ids.each do |msg_id|
            message = Message.find_by(id: msg_id)
            balance_manager = self.get_balance_manager_details_from_message_async(message)
            if balance_manager.present?
                bm = BalanceManager.new(balance_manager)
                bm.save
            end
        end
        ids
    end

    def self.get_balance_manager_details_from_message_async(message)
        balance_manager  = nil
        if message.present?
            case message.sender.downcase
            when "bkash"
                balance_manager = self.bkash_balance_manager(message)
            when "nagad"
                balance_manager = self.nagad_balance_manager(message)
            when "upay"
                balance_manager = self.upay_balance_manager(message)
            when "rocket"
                balance_manager = self.rocket_balance_manager(message)
            end
        end
        balance_manager
    end

    def self.nagad_balance_manager(message)
        case message.transaction_type
        when B2BTransfer
            self.b2b_transfer_nagad(message)
        when B2BReceived
            self.b2b_received_nagad(message)
        when CASH_IN
            self.cash_in_nagad(message)
        when CASH_OUT
            self.cash_out_nagad(message)
        end
    end

    def self.b2b_transfer_nagad(message)
        m_pattern = Regexp.new(B2BTransferRegexPatternNagad, Regexp::IGNORECASE)
        match_str = m_pattern.match(message.text_message)
        self.calculate_balance_manager(match_str, message)
    end

    def self.b2b_received_nagad(message)
        m_pattern = Regexp.new(B2BReceivedRegexPatternNagad, Regexp::IGNORECASE)
        match_str = m_pattern.match(message.text_message)
        self.calculate_balance_manager(match_str, message)
    end

    def self.cash_in_nagad(message)
        m_pattern = Regexp.new(CashInRegexPatternNagad, Regexp::IGNORECASE)
        match_str = m_pattern.match(message.text_message)
        self.calculate_balance_manager(match_str, message)
    end

    def self.cash_out_nagad(message)
        m_pattern = Regexp.new(CashOutRegexPatternNagad, Regexp::IGNORECASE)
        match_str = m_pattern.match(message.text_message)
        self.calculate_balance_manager(match_str, message)
    end

    def self.upay_balance_manager(message)
        case message.transaction_type
        when B2BTransfer
            self.b2b_transfer_upay(message)
        when B2BReceived
            self.b2b_received_upay(message)
        when CashIn
            self.cash_in_upay(message)
        when CashOut
            self.cash_out_upay(message)
        end
    end

    def self.b2b_transfer_upay(message)
        m_pattern = Regexp.new(B2BTransferRegexPatternUPay, Regexp::IGNORECASE)
        match_str = m_pattern.match(message.text_message)
        self.calculate_balance_manager(match_str, message)
    end

    def self.b2b_received_upay(message)
        m_pattern = Regexp.new(B2BReceivedRegexPatternUPay, Regexp::IGNORECASE)
        match_str = m_pattern.match(message.text_message)
        self.calculate_balance_manager(match_str, message)
    end

    def self.cash_in_upay(message)
        m_pattern = Regexp.new(CashInRegexPatternUPay, Regexp::IGNORECASE)
        match_str = m_pattern.match(message.text_message)
        self.calculate_balance_manager(match_str, message)
    end
    
    def self.cash_out_upay(message)
        m_pattern = Regexp.new(CashOutRegexPatternUPay, Regexp::IGNORECASE)
        match_str = m_pattern.match(message.text_message)
        self.calculate_balance_manager(match_str, message)
    end


    def self.rocket_balance_manager(message)
        case message.transaction_type
        when B2BTransfer
            self.b2b_transfer_rocket(message)
        when B2BReceived
            self.b2b_received_rocket(message)
        when CashIn
            self.cash_in_rocket(message)
        when CashOut
            self.cash_out_rocket(message)
        end
    end

    def self.b2b_transfer_rocket(message)
        m_pattern = Regexp.new(B2B_TRANSFER_REGEX_PATTERN_ROCKET, Regexp::IGNORECASE)
        match_str = m_pattern.match(message.text_message)
        self.calculate_balance_manager(match_str, message)
    end

    def self.b2b_received_rocket(message)
        m_pattern = Regexp.new(B2B_RECEIVED_REGEX_PATTERN_ROCKET, Regexp::IGNORECASE)
        match_str = m_pattern.match(message.text_message)
        self.calculate_balance_manager(match_str, message)
    end

    def self.cash_in_rocket(message)
        m_pattern = Regexp.new(CASH_IN_REGEX_PATTERN_ROCKET, Regexp::IGNORECASE)
        match_str = m_pattern.match(message.text_message)
        self.calculate_balance_manager(match_str, message)
    end

    def self.cash_out_rocket(message)
        m_pattern = Regexp.new(CASH_OUT_REGEX_PATTERN_ROCKET, Regexp::IGNORECASE)
        match_str = m_pattern.match(message.text_message)
        self.calculate_balance_manager(match_str, message)
    end

    def self.bkash_balance_manager(message)
        case message.transaction_type
        when B2BTransfer
            self.b2b_transfer_bkash(message)
        when B2BReceived
            self.b2b_received_bkash(message)
        when CASH_IN
            self.cash_in_bkash(message)
        when CASH_OUT
            self.cash_out_bkash(message)
        end
    end

    def self.b2b_received_bkash(message)
        m_pattern = Regexp.new(B2BReceivedRegexPatternBkash, Regexp::IGNORECASE)
        match_str = m_pattern.match(message.text_message)
        self.calculate_balance_manager(match_str, message)
    end

    def self.cash_in_bkash(message)
        m_pattern = Regexp.new(CashInRegexPatternBkash, Regexp::IGNORECASE)
        match_str = m_pattern.match(message.text_message);
        self.calculate_balance_manager(match_str, message)
    end

    def self.cash_out_bkash(message)
        m_pattern = Regexp.new(CashOutRegexPatternBkash, Regexp::IGNORECASE)
        match_str = m_pattern.match(message.text_message)
        self.calculate_balance_manager(match_str, message)
    end

    def self.b2b_transfer_bkash(message)
        m_pattern = Regexp.new(B2BTransferRegexPatternBkash, Regexp::IGNORECASE)
        match_str = m_pattern.match(message.text_message)
        self.calculate_balance_manager(match_str, message)
    end

    def self.get_comminsion(commision_percentage, amount)
        commision = (commision_percentage / 100) * amount
        rounded_commision = commision.round(2)
        rounded_commision
    end

    def self.get_last_balance(agent_account_no)
        last_balance_detail = BalanceManager.where(agent_account_no: agent_account_no).order(created_at: :desc)
        last_balance_detail.present? ? last_balance_detail.try(:first).try(:last_balance) : 0
    end

    def self.calculate_balance_manager(match_str, message)
        balance_manager_model = {}
        if match_str
            amount_value = match_str["#{AmountGroupName}"]
            customer_account_value = match_str["#{CustomerAccountGroupName}"]
            commision_value = match_str["#{CommisionGroupName}"] rescue 0
            balance_value = match_str["#{BalanceGroupName}"]
            transaction_id_value = match_str["#{TransactionGroupName}"]
            date_value = match_str["#{DateGroupName}"]

            balance_status = "danger"
            agent_account_no = message.receiver.to_i
            last_balance = self.get_last_balance(agent_account_no)
            amount = amount_value.gsub(",", "").to_f

            commision_percentage = 0
            commision = 0
            if (message.transaction_type == CASH_IN || message.transaction_type == CASH_OUT)
                if message.sender.downcase == BKash
                    commision = self.get_comminsion(BKASH_COMMISION_PERCENTAGE, amount)
                elsif (message.sender.downcase == Nagad || message.sender.downcase == Upay || message.sender.downcase == Rocket)
                    commision = commision_value.gsub(",", "").to_f
                end
            end
            if last_balance > 0
                if message.transaction_type == B2BTransfer
                    balance_computed_value = last_balance - amount
                    balance_status = self.get_balance_status(balance_value.gsub(",", "").to_f, balance_computed_value, message.transaction_type)
                elsif message.transaction_type == B2BReceived
                    balance_computed_value = last_balance + amount
                    balance_status = self.get_balance_status(balance_value.gsub(",", "").to_f, balance_computed_value, message.transaction_type)
                elsif message.transaction_type == CASH_IN
                    balance_computed_value = last_balance - amount + commision
                    balance_status = self.get_balance_status(balance_value.gsub(",", "").to_f, balance_computed_value, message.transaction_type)
                elsif message.transaction_type == CASH_OUT
                    balance_computed_value = last_balance + amount + commision
                    balance_status = self.get_balance_status(balance_value.gsub(",", "").to_f, balance_computed_value, message.transaction_type)
                end
            end
            balance_manager_model[:agent_account_no] = agent_account_no
            balance_manager_model[:amount] = amount
            balance_manager_model[:commision] = commision
            if customer_account_value.include?("XXXX")
                customer_account_value = customer_account_value.gsub("XXXX", "0000").to_i
                balance_manager_model[:customer_account_no] = customer_account_value
                balance_manager_model[:is_privacy] = true
            else
                balance_manager_model[:customer_account_no] = customer_account_value.to_i
            end
            balance_manager_model[:date] = self.sql_date(date_value)
            balance_manager_model[:last_balance] = balance_value.gsub(",", "").to_f
            # balance_manager_model[:message] = message.text_message
            balance_manager_model[:old_balance] = last_balance
            balance_manager_model[:sender] = message.sender
            balance_manager_model[:transaction_id] = transaction_id_value
            balance_manager_model[:b_type] = message.transaction_type
            balance_manager_model[:user_id] = message.user_id
            balance_manager_model[:status] = balance_status
        end
        return balance_manager_model
    end

    def self.sql_date(date_string)
        datetime_format = "%d/%m/%Y %H:%M"
        DateTime.strptime(date_string, datetime_format)
    end

    def self.get_balance_status(balance_value, computed_balance, transaction_type)
        balance_diffrence = 0
        compare_balance_and_computed_balance = balance_value <=> computed_balance
        if compare_balance_and_computed_balance < 0
            balance_diffrence = computed_balance - balance_value
        elsif compare_balance_and_computed_balance > 0
            balance_diffrence = balance_value - computed_balance
        end
        max_balance_diff = (transaction_type === CASH_IN) ? CASHIN_MAX_BALANCE_DIFFERENCE : MAX_BALANCE_DIFFERENCE

        if balance_diffrence >= MIN_BALANCE_DIFFERENCE && balance_diffrence <= max_balance_diff
            return "success"
        elsif balance_diffrence >= max_balance_diff && balance_diffrence <= PRO_MAX_BALANCE_DIFFERENCE
            return "pending"
        else
            return "danger"
        end
    end

    def self.date_filter(where_sql_arr, options = {})
        sms_date = options[:sms_date]
        if sms_date.present?
            where_sql_arr << %|sms_date = '#{sms_date}'|
        end
        where_sql_arr
    end

    def self.reprocess_pending
        pending_balance_managers = BalanceManager.where(status: "pending").order(created_at: :desc)
        infected = []
        msg_p = []
        updated_bl = []
        pending_balance_managers.each do |bl|
			agent_account_no = bl.try(:agent_account_no)
            filtered_records = BalanceManager.where(agent_account_no: agent_account_no).where("created_at < '#{bl.created_at}'").order(created_at: :desc)
            if filtered_records.present? && filtered_records.count > 0
                old_balance = filtered_records.try(:first).last_balance
                if filtered_records.try(:first).last_balance === bl.old_balance
                    new_status = self.get_latest_status(bl, old_balance)
                    if new_status === "success"
                        bl.update(old_balance: old_balance, status: new_status)
                        updated_bl << bl.transaction_id
                    end
                else
                    # Get Old balance from previous record
                    new_status = self.get_latest_status(bl, old_balance)
                    if new_status === "success"
                        bl.update(old_balance: old_balance, status: new_status)
                        updated_bl << bl.transaction_id
                    end
                end
            end
	    end
        puts updated_bl
    end

    def self.get_latest_status(bl, old_balance)
        if bl.last_balance > 0
            if bl.b_type == B2BTransfer
                balance_computed_value = old_balance - bl.amount
                balance_status = self.get_balance_status(bl.last_balance, balance_computed_value, bl.b_type)
            elsif bl.b_type == B2BReceived
                balance_computed_value = old_balance + bl.amount
                balance_status = self.get_balance_status(bl.last_balance, balance_computed_value, bl.b_type)
            elsif bl.b_type == CASH_IN
                balance_computed_value = old_balance - bl.amount + bl.commision
                balance_status = self.get_balance_status(bl.last_balance, balance_computed_value, bl.b_type)
            elsif bl.b_type == CASH_OUT
                balance_computed_value = old_balance + bl.amount + bl.commision
                balance_status = self.get_balance_status(bl.last_balance, balance_computed_value, bl.b_type)
            end
        end
        balance_status
    end

end