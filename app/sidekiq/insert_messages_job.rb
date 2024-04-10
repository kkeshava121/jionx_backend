class InsertMessagesJob
  include Sidekiq::Job

  def perform(message)
    message = Message.new(message)
    if message.save
      if message.transaction_type != "Cash In"
        balance_manager = Message.get_balance_manager_details_from_message_async(message)
        if balance_manager.present?
            bm = BalanceManager.new(balance_manager)
            bm.save
        end
      end
    else
      puts "Message already exist"
    end
  end
end