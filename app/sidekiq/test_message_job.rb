class TestMessageJob
  include Sidekiq::Job

  def perform
    puts "Peform ======================================================>>>> SMS ARRIVED <<<<<================="
    # message = Message.new(message)
    # if message.save
    #   balance_manager = Message.get_balance_manager_details_from_message_async(message)
    #   if balance_manager.present?
    #       bm = BalanceManager.new(balance_manager)
    #       bm.save
    #   end
    # else
    #   puts "Message already exist"
    # end
  end
end