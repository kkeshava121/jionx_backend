class BalanceManager < ApplicationRecord
	belongs_to :user
	validates :transaction_id, uniqueness: { message: "Transaction id already exist"}
	enum :status, [:success, :pending, :fake, :rejected, :approved, :danger]

	# Class Methods
	class << self
		# To get sms list with filter
		def sms_by_filter(options, user)
			response = {}
			page_size =  options[:page_size].to_i
			page_number = options[:page_number].to_i
			message_type = options[:message_type]
			text_message = options[:text_message]
			sender = options[:sender]
			receiver = options[:receiver]
			sim_slot =  options[:sim_slot]
			sms_date =  options[:sms_date]
			where_sql_arr = []
			where_sql_arr << %|text_message LIKE '%#{text_message}%'| if text_message.present?
			where_sql_arr << %|LOWER(sender) = '#{sender.downcase}'| if sender.present?
			where_sql_arr << %|receiver = '#{receiver}'| if receiver.present?
			where_sql_arr << %|sim_slot = '#{sim_slot}'| if sim_slot.present?

			# Message Type Check
			case message_type
			when -1
			# Show all
			when 0..5
			where_sql_arr << %|sms_type = #{message_type}|
			end
			# Role Based check
			current_role = user.role.try(:name)
			case current_role
			when 'Agent'
				where_sql_arr << %|user_id = '#{user.id}'|
			when 'Merchant'
				agents = User.where(merchant_id: user.id)
				if agents.present?
					agent_ids = agents.pluck(:id)
				else
					agent_ids = []
				end
			end
			#Date Filter
			where_sql_arr = Message.date_filter(where_sql_arr, options)
			where_sql = where_sql_arr.join(" AND ")
			if current_role === "Merchant"
				filtered_record = Message.where(where_sql).where(user_id: agent_ids).order(created_at: :desc)
			else
				filtered_record = Message.where(where_sql).order(created_at: :desc)
			end
			total_rows = filtered_record.count
			messages = filtered_record.offset((page_number - 1) * page_size).limit(page_size)
			result = self.append_formated_date(messages, 'msg')
			response[:data] = result
			response[:total_rows] = total_rows
			response[:success] = true
			response[:message] = "success"
			response
		end

		# List API Filters
		def create_where_sql(options, user)
			@page_number = options[:page_number].to_i || 1
			@page_size = options[:page_size].to_i || 10
			sender = options[:sender]
			agent_account_no = options[:agent_account_no]
			balance_manager_filter = options[:balance_manager_filter]
			b_type = options[:b_type]
			transaction_id = options[:transaction_id]
			current_role = user.role.try(:name)
			where_sql_arr = []
			where_sql_arr << %|LOWER(sender) = '#{sender.downcase}'| if sender.present?
			where_sql_arr << %|agent_account_no = #{agent_account_no.to_i}| if agent_account_no.present?
			where_sql_arr << %|transaction_id = '#{transaction_id}'| if transaction_id.present?
			if current_role === "Merchant"
				where_sql_arr << %|b_type = 'Cash Out' AND amount >= 300|
			else
				where_sql_arr << %|b_type = '#{b_type}'| if b_type.present?
			end
			if balance_manager_filter > -1
				where_sql_arr << %|status = #{balance_manager_filter}|
			end
			#Date Filter
			where_sql_arr = self.date_filter(where_sql_arr, options)
			case current_role
			when 'Agent'
				where_sql_arr << %|user_id = '#{user.id}'|
			when 'Merchant'
				agents = User.where(merchant_id: user.id)
				if agents.present?
					@agent_ids = agents.pluck(:id)
				else
					@agent_ids = []
				end
			end
			@where_sql = where_sql_arr.join(" AND ")
		end

		# To Get The Balance Manager List
		def get_list(options, user)
			self.create_where_sql(options, user)
			if current_role === "Merchant"
				filtered_record = BalanceManager.where(@where_sql)
									.where(user_id: @agent_ids, status: ["success", "approved"])
									.where.not(b_type: "Cash In")
									.order(created_at: :desc)
			else
				filtered_record = BalanceManager
											.where(@where_sql)
											.where.not(b_type: "Cash In")
											.order(created_at: :desc)
			end
			total_rows = filtered_record.count

			records = filtered_record.offset((@page_number - 1) * @page_size).limit(@page_size)
			result = self.append_formated_date(records, 'bm')
			deliver_res(result, 200, "success", total_rows)
		end

		# To Create the api response
		def deliver_res(data, status, message, total_rows=0)
			{
				data: data,
				status: status,
				message: message,
				total_rows: total_rows
			}
		end

		def date_filter(where_sql_arr, options = {})
			from = options[:from]
			to = options[:to]
			if from.present? && to.present?
				where_sql_arr << %|date >= '#{from}' AND date <= '#{to}'|
			end
			where_sql_arr
		end

		def append_formated_date(balance_manager, type)
	        result = []
	        balance_manager.each do |bm|
	        	date = type === "bm" ? bm.try(:date) : bm.try(:sms_date) 
	        	# date_in_words = time_ago_in_words(date)
	            json_bm = bm.as_json
	            json_bm["formated_date"] = date_format(date)
	            json_bm["formated_created_at"] = created_at_format(bm.try(:created_at).in_time_zone('Asia/Dhaka'))
	            json_bm["date_in_words"] = ""
	            result << json_bm
	        end
			if type === "bm"
				result = result.uniq { |record| record['transaction_id'] }
			end
	        result
	    end

	    def date_format(date)
	    	date.strftime("%Y-%m-%d %I:%M %p")
	    end

	    def created_at_format(date)
	    	date.strftime("%Y-%m-%d %H:%M:%S")
	    end


	    def time_ago_in_words(date)
				seconds = (Time.now.in_time_zone('Asia/Dhaka') - date).round

				case seconds
				when 0..59
					"#{seconds} seconds ago"
				when 60..3599
					minutes = seconds / 60
					"#{minutes} #{pluralize(minutes, 'minute')} ago"
				when 3600..86_399
					hours = seconds / 3600
					"#{hours} #{pluralize(hours, 'hour')} ago"
				else
					days = seconds / 86_400
					"#{days} #{pluralize(days, 'day')} ago"
				end
			end

			def pluralize(count, singular)
		  	count == 1 ? singular : "#{singular}s"
			end
	end
	# End class methods
end
