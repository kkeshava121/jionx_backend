namespace :remove_deuplicate_modems do
	desc "To Remove Deuplicate Modems"
	task process: :environment do
		modems = Modem.all.order(created_at: :desc)
		modems.each do |modem|
			phone_number = modem.try(:phone_number)
			device_id = modem.try(:device_id)
			duplicate_modems = Modem.where(phone_number: phone_number, device_id: device_id).where.not(id: modem.id)
			if duplicate_modems.count > 0
				duplicate_modems.delete_all
			end
		end		
	end
end