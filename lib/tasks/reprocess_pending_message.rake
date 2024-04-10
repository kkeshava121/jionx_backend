namespace :reprocess_pending_message do
	desc "To reprocess pending Balance Manager records"
	  task process: :environment do
		Message.reprocess_pending
	  end
end
