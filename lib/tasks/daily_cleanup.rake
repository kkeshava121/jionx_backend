# lib/tasks/daily_cleanup.rake

namespace :daily_cleanup do
  desc 'Delete messages and balance managers older than 3 months'
  task delete_data: :environment do
    puts "Start Daily Cleanup"

    three_months_ago = 3.months.ago

    # Delete messages older than three months

    old_messages = Message.where('created_at < ?', three_months_ago)
    old_messages.destroy_all

    puts "#{old_messages.count} messages deleted."

    # Delete Balance Managers older than three months
    old_balance_managers = BalanceManager.where('created_at < ?', three_months_ago)
    old_balance_managers.destroy_all

    puts "#{old_balance_managers.count} balance managers deleted."
  end
end

# 0 3 * * * cd /home/ubuntu/apps/jionex_backend && bin/rails daily_cleanup:delete_data RAILS_ENV=production