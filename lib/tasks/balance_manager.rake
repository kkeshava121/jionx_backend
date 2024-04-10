namespace :balance_manager do
  desc "TODO"
  task remove_duplicate_record: :environment do
    all_records_count = BalanceManager.group(:transaction_id).count
    all_records_count.each_slice(4) do |record, next_rec|
      puts "TR: #{record[0]}"
      if record[1] > 1
        bl = BalanceManager.where(transaction_id: record[0]).order(created_at: :desc).last
        if bl.destroy
          puts "Destroy --> #{record[0]}"
        end
      end
    end
  end

end
